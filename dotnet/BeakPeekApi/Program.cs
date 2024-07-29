using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Models;
using BeakPeekApi.Helpers;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddCors(options => options.AddDefaultPolicy(
                include =>
                {
                    include.AllowAnyHeader();
                    include.AllowAnyMethod();
                    include.AllowAnyOrigin();
                }));


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpClient();

var connection = String.Empty;

builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();

if (builder.Environment.IsDevelopment())
{

    connection = builder.Configuration.GetConnectionString("DefaultConnection");
}
else
{
    var envConnection = Environment.GetEnvironmentVariable("AZURE_SQL_CONNECTIONSTRING");
    if (!string.IsNullOrEmpty(envConnection))
    {
        connection = envConnection;
    }
    else
    {
        throw new InvalidOperationException("Connection string not found.");
    }
}

builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(connection));
builder.Services.AddTransient<CsvImporter>();
builder.Services.AddTransient<BirdInfoHelper>();

var app = builder.Build();

try
{

    using (var scope = app.Services.CreateScope())
    {
        var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        if (builder.Environment.IsDevelopment())
        {
            dbContext.Database.Migrate();
        }
        /* else
        {
            if (dbContext.Database.GetPendingMigrations().Any())
            {
                dbContext.Database.Migrate();
            }
        } */

        var csvImporter = scope.ServiceProvider.GetRequiredService<CsvImporter>();
        if (builder.Environment.IsDevelopment())
        {
            csvImporter.ImportAllCsvData("/data");
        }
        // else
        // {
        //     var csvDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "res", "species");
        //     if (!Directory.Exists(csvDirectoryPath))
        //     {
        //         throw new DriveNotFoundException($"CSV directory not found: {csvDirectoryPath}");
        //     }
        //     csvImporter.ImportAllCsvData(csvDirectoryPath);
        // }
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
