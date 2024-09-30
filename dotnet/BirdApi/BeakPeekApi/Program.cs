using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Models;
using BeakPeekApi.Helpers;
using Serilog;
using BeakPeekApi.Services;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateBootstrapLogger();

builder.Host.UseSerilog((context, services, configuration) => configuration
    .ReadFrom.Configuration(context.Configuration)
    .ReadFrom.Services(services)
    .Enrich.FromLogContext()
    .WriteTo.Console());

builder.Services.AddCors(options => options.AddDefaultPolicy(
                include =>
                {
                    include.AllowAnyHeader();
                    include.AllowAnyMethod();
                    include.AllowAnyOrigin();
                }));


builder.Services.AddSingleton<BlobStorageService>();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpClient();

var connection = String.Empty;

builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();

/// Use the correct environment variables depending on if the environment is
/// development or not
/// first flow is for if the environment is not development
if (!builder.Environment.IsDevelopment())
{
    // var envConnection = Environment.GetEnvironmentVariable("SQLCONNSTR_AZURE_SQL_CONNECTIONSTRING");
    var envConnection = builder.Configuration.GetConnectionString("AZURE_SQL_CONNECTIONSTRING");
    if (!string.IsNullOrEmpty(envConnection))
    {
        connection = envConnection;
    }
    else
    {
        var second_backup = builder.Configuration.GetConnectionString("SQLCONNSTR_AZURE_SQL_CONNECTIONSTRING");
        if (!string.IsNullOrEmpty(second_backup))
        {
            connection = second_backup;
        }
        else
        {
            throw new FileNotFoundException($"Connection string not found. \n {builder.Configuration.ToString()}");
        }
    }
}
else
{
    /// use the default connection string in developent
    connection = builder.Configuration.GetConnectionString("DefaultConnection");
}

builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(connection));
builder.Services.AddTransient<GeneralHelper>();
builder.Services.AddTransient<CsvImporter>();
builder.Services.AddTransient<BirdInfoHelper>();
builder.Services.AddTransient<BirdImageHelper>();
builder.Services.AddControllersWithViews()
    .AddNewtonsoftJson(options =>
            options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );

var app = builder.Build();

try
{
    using (var scope = app.Services.CreateScope())
    {
        var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        if (dbContext.Database.GetPendingMigrations().Any())
        {
            dbContext.Database.Migrate();

            var csvImporter = scope.ServiceProvider.GetRequiredService<CsvImporter>();
            if (builder.Environment.IsDevelopment())
            {
                if (File.Exists("/species_list/south_africa.csv"))
                {
                    if (Directory.Exists("/data"))
                    {
                        csvImporter.ImportBirds("/species_list/south_africa.csv");
                        csvImporter.ImportAllCsvData("/data");
                    }
                }
                else
                    throw new Exception("No species list found.");
            }
            else
            {
                var csv_species_list = Path.Combine(Directory.GetCurrentDirectory(), "res", "species_list", "south_africa.csv");
                if (File.Exists(csv_species_list))
                {
                    // csvImporter.ImportBirds(csv_species_list);
                }
                var csv_pentad_dir = Path.Combine(Directory.GetCurrentDirectory(), "res", "species");
                if (Directory.Exists(csv_pentad_dir))
                {
                    /// NOTE:
                    /// only enable this for development or running it locally as
                    /// it will import every entry which is very intensive on the
                    /// database and the container and will probalby cause the api
                    /// to not deploy

                    // csvImporter.ImportAllCsvData(csv_pentad_dir);
                }
            }
        }

    }
}
catch (Exception ex)
{
    Console.WriteLine($"Exception during startup: {ex.Message}");
    Console.WriteLine(ex.StackTrace);
    throw;
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors();
app.UseAuthorization();
app.UseAuthentication();
app.MapControllers();

app.Run();
// Azure run
