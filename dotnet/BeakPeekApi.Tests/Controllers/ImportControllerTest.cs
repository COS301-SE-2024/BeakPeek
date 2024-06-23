using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;
using BeakPeekApi.Controllers;
using BeakPeekApi.Helpers;

public class ImportControllerTests
{
    private readonly Mock<CsvImporter> _mockCsvImporter;
    private readonly ImportController _controller;

    public ImportControllerTests()
    {
        _mockCsvImporter = new Mock<CsvImporter>(MockBehavior.Strict, null);
        _controller = new ImportController(_mockCsvImporter.Object);
    }

    [Fact]
    public async Task ImportData_ShouldReturnOk()
    {
        // Arrange
        var fileContent = "Pentad;Spp;Common_group;Common_species;Genus;Species;Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec;Total_Records;Total_Cards;ReportingRate\n" +
                          "1234;1;Group;Species;Genus;Species;1;1;1;1;1;1;1;1;1;1;1;1;10;2;50.0\n";
        var fileName = "test.csv";
        var stream = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(fileContent));
        var formFile = new FormFile(stream, 0, stream.Length, "file", fileName);

        _mockCsvImporter.Setup(m => m.ImportCsvData(It.IsAny<string>(), It.IsAny<string>()));

        // Act
        var result = await _controller.ImportData(formFile, "TestProvince");

        // Assert
        var okResult = Assert.IsType<OkResult>(result);
        Assert.Equal(StatusCodes.Status200OK, okResult.StatusCode);
        _mockCsvImporter.Verify(m => m.ImportCsvData(It.IsAny<string>(), "TestProvince"), Times.Once);
    }

    [Fact]
    public async Task ReplaceData_ShouldReturnOk()
    {
        // Arrange
        var fileContent = "Pentad;Spp;Common_group;Common_species;Genus;Species;Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec;Total_Records;Total_Cards;ReportingRate\n" +
                          "1234;1;Group;Species;Genus;Species;1;1;1;1;1;1;1;1;1;1;1;1;10;2;50.0\n";
        var fileName = "test.csv";
        var stream = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(fileContent));
        var formFile = new FormFile(stream, 0, stream.Length, "file", fileName);

        _mockCsvImporter.Setup(m => m.ReplaceProvinceData(It.IsAny<string>(), It.IsAny<string>()));

        // Act
        var result = await _controller.ReplaceData(formFile, "TestProvince");

        // Assert
        var okResult = Assert.IsType<OkResult>(result);
        Assert.Equal(StatusCodes.Status200OK, okResult.StatusCode);
        _mockCsvImporter.Verify(m => m.ReplaceProvinceData(It.IsAny<string>(), "TestProvince"), Times.Once);
    }

    [Fact]
    public void ClearData_ShouldReturnOk()
    {
        // Arrange
        _mockCsvImporter.Setup(m => m.ClearProvinceData(It.IsAny<string>()));

        // Act
        var result = _controller.ClearData("TestProvince");

        // Assert
        var okResult = Assert.IsType<OkResult>(result);
        Assert.Equal(StatusCodes.Status200OK, okResult.StatusCode);
        _mockCsvImporter.Verify(m => m.ClearProvinceData("TestProvince"), Times.Once);
    }
}
