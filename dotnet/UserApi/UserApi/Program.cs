using System.Text;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using UserApi.Data;
using UserApi.Models;
using UserApi.Services;

/// NOTE: to set enviroment variables so that they can be accessed the same way
/// that nested key value pairs are accessed in the appsetting (e.g. "ConnectionStrings:DefaultConnection")
/// then you set an enviroment variable with the name being the same as the json
/// path replacing ":" with "__" (two underscores)
/// e.g. ConnectionStrings__DefaultConnection=<value>
var builder = WebApplication.CreateBuilder(args);
var services = builder.Services;
builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();
var configuration = builder.Configuration;

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (!builder.Environment.IsDevelopment())
{
    connectionString = builder.Configuration.GetConnectionString("SQLCONNSTR_DefaultConnection") ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
}


services.AddDbContext<ApplicationDbContext>(options =>
        options.UseSqlServer(connectionString));

services.AddDatabaseDeveloperPageExceptionFilter();

services
    .AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    })
    .AddCookie(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
    {
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = configuration["Jwt:Issuer"],
            ValidAudience = configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:Key"]))
        };
    })
    .AddGoogle(googleOptions =>
    {
        googleOptions.ClientId = configuration["Authentication:Google:ClientId"];
        googleOptions.ClientSecret = configuration["Authentication:Google:ClientSecret"];
    });

services.AddIdentity<AppUser, AppRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultUI()
    .AddApiEndpoints()
    .AddDefaultTokenProviders();


services.AddDetection();
services.AddControllersWithViews();
services.AddRazorPages();
services.AddMvc().AddSessionStateTempDataProvider();

services.AddSession(options =>
    {
        options.IdleTimeout = TimeSpan.FromSeconds(10);
        options.Cookie.HttpOnly = true;
        options.Cookie.IsEssential = true;
    });

services.AddTransient<AuthHandler>();


// services.AddAuthorization();

services.ConfigureApplicationCookie(options =>
{
    options.Cookie.HttpOnly = true;
    options.ExpireTimeSpan = TimeSpan.FromMinutes(60);
    options.SlidingExpiration = true;
    options.LoginPath = "/Identity/Account/Login";
    options.LogoutPath = "/Identity/Account/Logout";
    options.AccessDeniedPath = "/Identity/Account/AccessDenied";
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
        {
            options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
            {
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.Http,
                Scheme = "Bearer"
            });
            options.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    Array.Empty<string>()
                }
            });
        });

var app = builder.Build();


try
{
    using (var scope = app.Services.CreateScope())
    {
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        if (dbContext.Database.GetPendingMigrations().Any())
        {
            dbContext.Database.Migrate();
        }
    }
}
catch (Exception ex)
{
    Console.WriteLine($"Exception during startup: {ex.Message}");
    Console.WriteLine(ex.StackTrace);
    throw;
}

app.MapIdentityApi<AppUser>();
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// app.UseHttpsRedirection();

app.UseDetection();

app.UseRouting();

app.UseAuthentication();// Must come before UseAuthorization
app.UseAuthorization();

app.UseSession();
app.UseStaticFiles();

app.Use(async (context, next) =>
{
    var token = context.Session.GetString("Token");
    if (!string.IsNullOrEmpty(token))
    {
        context.Request.Headers.Add("Authorization", "Bearer " + token);
        Console.WriteLine("token sent");
    }

    await next();
});

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllerRoute(
            name: "default",
            pattern: "{controller=Home}/{action=Index}/{id?}");
    endpoints.MapRazorPages();
});

using (var scope = app.Services.CreateScope())
{
    var scoped_services = scope.ServiceProvider;
    var loggerFactory = scoped_services.GetRequiredService<ILoggerFactory>();
    try
    {
        var context = scoped_services.GetRequiredService<ApplicationDbContext>();
        var userManager = scoped_services.GetRequiredService<UserManager<AppUser>>();
        var roleManager = scoped_services.GetRequiredService<RoleManager<AppRole>>();
        await ContextSeed.SeedRolesAsync(userManager, roleManager);
    }
    catch (Exception ex)
    {
        var logger = loggerFactory.CreateLogger<Program>();
        logger.LogError(ex, "An error occured while seeding the DB.");
    }
}

app.Run();
