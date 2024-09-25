using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Helpers;
using BeakPeekApi.Models;

public class CsvImporterTests
{
    private readonly AppDbContext _context;
    private readonly CsvImporter _csvImporter;

    public CsvImporterTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(options);
        _csvImporter = new CsvImporter(_context);

        _context.ProvincesList.AddRange(
                new ProvinceList { Id = 1, Name = "easterncape", Province_Birds = { } },
                new ProvinceList { Id = 2, Name = "freestate", Province_Birds = { } },
                new ProvinceList { Id = 3, Name = "gauteng", Province_Birds = { } },
                new ProvinceList { Id = 4, Name = "kwazulunatal", Province_Birds = { } },
                new ProvinceList { Id = 5, Name = "limpopo", Province_Birds = { } },
                new ProvinceList { Id = 6, Name = "mpumalanga", Province_Birds = { } },
                new ProvinceList { Id = 7, Name = "northerncape", Province_Birds = { } },
                new ProvinceList { Id = 8, Name = "northwest", Province_Birds = { } },
                new ProvinceList { Id = 9, Name = "westerncape", Province_Birds = { } }
                );
        _context.SaveChanges();
    }

    public void Dispose()
    {
        _context.Dispose();
    }

    [Fact]
    public void ImportBirds_ImportsBirds()
    {
        var directoryPath = "../../../species_list/south_africa.csv";

        _csvImporter.ImportBirds(directoryPath);

        Assert.Equal(872, _context.Birds.Count());
        this.Dispose();
    }

    [Fact]
    public void ImportCsvData_ShouldImportData()
    {


        var directoryPath = "../../../species_list/south_africa.csv";

        _csvImporter.ImportBirds(directoryPath);
        // Arrange
        var csvData = "Pentad,Spp,Common_group,Common_species,Genus,Species,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,Total_Records,Total_Cards,ReportingRate\r\n" + "69_69,6,Grebe,Little,Tachybaptus,ruficollis,100.0,0.0,,,100.0,0.0,0.0,,33.3,0.0,0.0,33.3,6,22,27.3\r\n";
        var filePath = Path.GetTempFileName();
        File.WriteAllText(filePath, csvData);
        var provinceName = "gauteng";

        // Act
        _csvImporter.ImportCsvData(filePath, provinceName);

        // Assert
        var pentad_entry = _context.Gauteng.Include(p => p.Bird).FirstOrDefault();
        Assert.NotNull(pentad_entry);
        // Assert.Single(pentad_entry.Bird);
        Assert.Equal("Grebe", pentad_entry.Bird?.Common_group);
        var birdRecord = pentad_entry.Bird;
        Assert.NotNull(birdRecord);
        Assert.Equal(6, birdRecord.Ref);
        Assert.Equal("Grebe", birdRecord.Common_group);
        Assert.Equal("Little", birdRecord.Common_species);
        Assert.Equal("Tachybaptus", birdRecord.Genus);
        Assert.Equal("ruficollis", birdRecord.Species);
        Assert.Equal(6, pentad_entry.Total_Records);
        Assert.Equal(22, pentad_entry.Pentad?.Total_Cards);
        Assert.Equal(27.3, pentad_entry.ReportingRate);

        this.Dispose();

    }

    [Fact]
    public void ImportAllCsvData_ShouldCallImportCsvDataForEachCsvFile()
    {

        // Arrange
        var directoryPath = "../../../testData/";
        var csvFiles = Directory.GetFiles(directoryPath, "*.csv");

        var birdSpecies = "../../../species_list/south_africa.csv";
        _csvImporter.ImportBirds(birdSpecies);
        // Act
        _csvImporter.ImportAllCsvData(directoryPath);

        // Assert

        Assert.Equal(49, _context.Easterncape.Count());
        Assert.Equal(49, _context.Freestate.Count());
        Assert.Equal(49, _context.Gauteng.Count());
        Assert.Equal(49, _context.Kwazulunatal.Count());
        Assert.Equal(49, _context.Limpopo.Count());
        Assert.Equal(49, _context.Mpumalanga.Count());
        Assert.Equal(49, _context.Northerncape.Count());
        Assert.Equal(49, _context.Northwest.Count());
        Assert.Equal(49, _context.Westerncape.Count());

        this.Dispose();
    }


}

