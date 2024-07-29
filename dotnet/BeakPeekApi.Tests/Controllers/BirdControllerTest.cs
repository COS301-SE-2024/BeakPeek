using BeakPeekApi.Controllers;
using BeakPeekApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

public class BirdControllerTest
{
    private readonly AppDbContext _context;
    private readonly BirdController _controller;

    public BirdControllerTest()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase")
            .Options;
        _context = new AppDbContext(options);
        _controller = new BirdController(_context);

        SeedDatabase();
    }

    private void SeedDatabase()
    {
        // Clear the database
        _context.Birds.RemoveRange(_context.Birds);
        _context.Provinces.RemoveRange(_context.Provinces);
        _context.SaveChanges();

        var birds = new List<Bird>
        {
            new Bird { Id = 1, Pentad = "1234", Spp = 1, Common_group = "Group1", Common_species = "Species1", Genus = "Genus1", Species = "Species1", ProvinceId = 1 },
            new Bird { Id = 2, Pentad = "5678", Spp = 2, Common_group = "Group2", Common_species = "Species2", Genus = "Genus2", Species = "Species2" , ProvinceId = 1 }
        };


        var birds_2 = new List<Bird>
        {
            new Bird { Id = 4, Pentad = "9012", Spp = 2, Common_group = "Group2", Common_species = "Species2", Genus = "Genus2", Species = "Species2" , ProvinceId = 2 },
            new Bird { Id = 5, Pentad = "3456", Spp = 3, Common_group = "Group3", Common_species = "Species3", Genus = "Genus3", Species = "Species3" , ProvinceId = 2 }
        };

        var provinces = new List<Province> {
            new Province { Id = 1, Name = "test_province_1", Birds = birds },
            new Province { Id = 2, Name = "test_province_2", Birds = birds_2 }
        };

        _context.Provinces.AddRange(provinces);
        _context.Birds.AddRange(birds);
        _context.Birds.AddRange(birds_2);
        _context.SaveChanges();
    }

    [Fact]
    public async Task GetBirds_ReturnsAllBirds()
    {
        // Act
        var result = await _controller.GetBirds();

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<Bird>>>(result);
        var returnValue = Assert.IsType<List<Bird>>(actionResult.Value);
        Assert.Equal(4, returnValue.Count);
    }

    [Fact]
    public async Task GetBird_ReturnsBirdById()
    {
        // Arrange
        var birdId = 1;

        // Act
        var result = await _controller.GetBird(birdId);

        // Assert
        var actionResult = Assert.IsType<ActionResult<Bird>>(result);
        var returnValue = Assert.IsType<Bird>(actionResult.Value);
        Assert.Equal(birdId, returnValue.Id);
    }

    [Fact]
    public async Task GetBird_ReturnsNotFoundForInvalidId()
    {
        // Arrange
        var birdId = 999;

        // Act
        var result = await _controller.GetBird(birdId);

        // Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task SearchBirdSpecies_ReturnsMatchingBirds()
    {
        // Act
        var result = await _controller.SearchBirdSpecies("Genus1", "Species1");

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<Bird>>>(result);
        var returnValue = Assert.IsType<List<Bird>>(actionResult.Value);
        Assert.Single(returnValue);
        Assert.Equal("Genus1", returnValue[0].Genus);
        Assert.Equal("Species1", returnValue[0].Common_species);
    }

    [Fact]
    public async Task PostBirds_AddsBirdToContext()
    {
        // Arrange
        var bird = new Bird { Id = 3, Pentad = "91011", Spp = 3, Common_group = "Group3", Common_species = "Species3", Genus = "Genus3", Species = "Species3", ProvinceId = 1 };

        // Act
        var result = await _controller.PostBirds(bird);

        // Assert
        var actionResult = Assert.IsType<ActionResult<Bird>>(result);
        var createdAtActionResult = Assert.IsType<CreatedAtActionResult>(actionResult.Result);
        var returnValue = Assert.IsType<Bird>(createdAtActionResult.Value);
        Assert.Equal(bird.Pentad, returnValue.Pentad);

        var birds = await _context.Birds.ToListAsync();
        Assert.Equal(5, birds.Count);
    }

    [Fact]
    public async Task PutBird_UpdatesBirdInContext()
    {
        // Arrange
        var birdId = 1;
        var bird = _context.Birds.First(b => b.Id == birdId);
        bird.Common_species = "UpdatedSpecies";

        // Act
        var result = await _controller.PutBird(bird.Pentad, bird);

        // Assert
        Assert.IsType<NoContentResult>(result);
        var updatedBird = await _context.Birds.FindAsync(birdId);
        Assert.Equal("UpdatedSpecies", updatedBird.Common_species);
    }

    [Fact]
    public async Task PutBird_ReturnsBadRequestForMismatchedId()
    {
        // Arrange
        var pentad = "1234";
        var bird = new Bird { Id = 6, Pentad = "5678", Spp = 2, Common_group = "Group2", Common_species = "Species2", Genus = "Genus2", Species = "Species2" };

        // Act
        var result = await _controller.PutBird(pentad, bird);

        // Assert
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task DeleteBird_RemovesBirdFromContext()
    {
        // Arrange
        var birdId = 1;

        // Act
        var result = await _controller.DeleteBird(birdId);

        // Assert
        Assert.IsType<NoContentResult>(result);
        var birds = await _context.Birds.ToListAsync();
        birds.Count().Equals(3);
    }

    [Fact]
    public async Task DeleteBird_ReturnsNotFoundForInvalidId()
    {
        // Arrange
        var birdId = 999;

        // Act
        var result = await _controller.DeleteBird(birdId);

        // Assert
        Assert.IsType<NotFoundResult>(result);
    }


    [Fact]
    public async Task GetBirdsByPentad_ReturnsBirdsByPentad()
    {
        // Arrange

        var pentad = "1234";

        // Act
        var result = await _controller.GetBirdsInPentad(pentad);

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<Bird>>>(result);
        var okResult = actionResult.Result as OkObjectResult;
        Assert.NotNull(okResult);

        var returnValue = Assert.IsType<List<Bird>>(okResult.Value);
        Assert.Single(returnValue);
        Assert.Equal(pentad, returnValue[0].Pentad);
    }



    [Fact]
    public async Task GetBirdsByPentad_ReturnsNotFoundForInvalidPentad()
    {
        // Arrange
        var pentad = "999";

        // Act
        var result = await _controller.GetBirdsInPentad(pentad);

        // Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetBirdsInProvince_ReturnsBirdsInProvince()
    {
        var province = "test_province_1";

        // Act
        var result = await _controller.GetBirdsInProvince(province);

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<Bird>>>(result);
        var okResult = actionResult.Result as OkObjectResult;
        Assert.NotNull(okResult);

        var returnValue = Assert.IsType<List<Bird>>(okResult.Value);
        Assert.Equal(2, returnValue.Count());
        Assert.Equal(province, returnValue[0].Province.Name);
    }

    [Fact]
    public async Task GetBirdsInPovince_ReturnsNotFound()
    {
        string province = "test_province_3";

        var result = await _controller.GetBirdsInProvince(province);

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task GetNumBirdByProvince_ReturnsNumber()
    {
        string province = "test_province_2";

        var result = await _controller.GetNumBirdsByProvince(province);

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);
        var objectResult = Assert.IsType<int>(actionResult.Value);

        objectResult.Equals(2);
    }

    [Fact]
    public async Task GetNumBirdByProvince_ReturnsNotFound()
    {
        string province = "test_province_3";
        var result = await _controller.GetNumBirdsByProvince(province);

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task GetNumBirdsReturnsNumber()
    {
        var result = await _controller.GetNumBirds();

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);

        var objectResult = Assert.IsType<int>(actionResult.Value);

        objectResult.Equals(4);
    }

}
