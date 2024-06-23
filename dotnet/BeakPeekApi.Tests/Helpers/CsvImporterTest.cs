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
            .UseInMemoryDatabase(databaseName: "CsvTestDatabase")
            .Options;
        _context = new AppDbContext(options);
        _csvImporter = new CsvImporter(_context);
    }

    [Fact]
    public void ImportCsvData_ShouldImportData()
    {
        // Arrange
        var csvData = "Pentad,Spp,Common_group,Common_species,Genus,Species,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,Total_Records,Total_Cards,ReportingRate\r\n" + "2505_2835,6,Grebe,Little,Tachybaptus,ruficollis,100.0,0.0,,,100.0,0.0,0.0,,33.3,0.0,0.0,33.3,6,22,27.3\r\n";
        var filePath = Path.GetTempFileName();
        File.WriteAllText(filePath, csvData);
        var provinceName = "TestProvince";

        // Act
        _csvImporter.ImportCsvData(filePath, provinceName);

        // Assert
        var province = _context.Provinces.Include(p => p.Birds).FirstOrDefault(p => p.Name == provinceName);
        Assert.NotNull(province);
        Assert.Single(province.Birds);
        var birdRecord = province.Birds.First();
        Assert.Equal("2505_2835", birdRecord.Pentad);
        Assert.Equal(6, birdRecord.Spp);
        Assert.Equal("Grebe", birdRecord.Common_group);
        Assert.Equal("Little", birdRecord.Common_species);
        Assert.Equal("Tachybaptus", birdRecord.Genus);
        Assert.Equal("ruficollis", birdRecord.Species);
        Assert.Equal(6, birdRecord.Total_Records);
        Assert.Equal(22, birdRecord.Total_Cards);
        Assert.Equal(27, 3, birdRecord.ReportingRate);
    }

    [Fact]
    public void ClearProvinceData_ShouldRemoveData()
    {
        var province = _context.Provinces.Where(p => p.Name == "TestProvince").ToList()[0];
        // Arrange
        var birdRecord = new Bird
        {
            Pentad = "1234",
            Spp = 1,
            Province = province,
            Common_group = "Group",
            Common_species = "Species",
            Genus = "Genus",
            Species = "Species",
            Total_Records = 10,
            Total_Cards = 2,
            ReportingRate = 50.0
        };
        _context.Birds.Add(birdRecord);
        _context.SaveChanges();

        // Act
        _csvImporter.ClearProvinceData("TestProvince");

        // Assert
        var records = _context.Birds.Where(r => r.ProvinceId == province.Id).ToList();
        Assert.Empty(records);
    }

    [Fact]
    public void ReplaceProvinceData_ShouldReplaceData()
    {
        // Arrange
        var existingProvince = _context.Provinces.Where(p => p.Name == "TestProvince").ToList()[0];
        var existingBird = new Bird
        {
            Pentad = "5678",
            Spp = 1,
            Province = existingProvince,
            Common_group = "Group",
            Common_species = "Species",
            Genus = "Genus",
            Species = "Species",
            Total_Records = 10,
            Total_Cards = 2,
            ReportingRate = 50.0
        };
        _context.Birds.Add(existingBird);
        _context.SaveChanges();

        var newCsvData = "Pentad,Spp,Common_group,Common_species,Genus,Species,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,Total_Records,Total_Cards,ReportingRate\r\n" + "2505_2835,6,Grebe,Little,Tachybaptus,ruficollis,100.0,0.0,,,100.0,0.0,0.0,,33.3,0.0,0.0,33.3,6,22,27.3\r\n";
        var filePath = Path.GetTempFileName();
        File.WriteAllText(filePath, newCsvData);

        // Act
        _csvImporter.ReplaceProvinceData(filePath, "TestProvince");

        // Assert
        var province = _context.Provinces.Include(p => p.Birds).FirstOrDefault(p => p.Name == "TestProvince");
        Assert.NotNull(province);
        Assert.Single(province.Birds);
        var birdRecord = province.Birds.First();
        Assert.Equal("2505_2835", birdRecord.Pentad);
        Assert.Equal(6, birdRecord.Spp);
        Assert.Equal("Grebe", birdRecord.Common_group);
        Assert.Equal("Little", birdRecord.Common_species);
        Assert.Equal("Tachybaptus", birdRecord.Genus);
        Assert.Equal("ruficollis", birdRecord.Species);
        Assert.Equal(6, birdRecord.Total_Records);
        Assert.Equal(22, birdRecord.Total_Cards);
        Assert.Equal(27.3, birdRecord.ReportingRate);
    }
}
