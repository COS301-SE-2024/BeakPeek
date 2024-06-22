using BeakPeekApi.Controllers;
using BeakPeekApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

public class BirdControllerTests
{
    private readonly AppDbContext _context;
    private readonly BirdController _controller;

    public BirdControllerTests()
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
            new Bird { Id = 1, Pentad = "1234", Spp = 1, Common_group = "Group1", Common_species = "Species1", Genus = "Genus1", Species = "Species1" },
            new Bird { Id = 2, Pentad = "5678", Spp = 2, Common_group = "Group2", Common_species = "Species2", Genus = "Genus2", Species = "Species2" }
        };

        _context.Birds.AddRange(birds);
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
        Assert.Equal(2, returnValue.Count);
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
        var bird = new Bird { Id = 3, Pentad = "91011", Spp = 3, Common_group = "Group3", Common_species = "Species3", Genus = "Genus3", Species = "Species3" };

        // Act
        var result = await _controller.PostBirds(bird);

        // Assert
        var actionResult = Assert.IsType<ActionResult<Bird>>(result);
        var createdAtActionResult = Assert.IsType<CreatedAtActionResult>(actionResult.Result);
        var returnValue = Assert.IsType<Bird>(createdAtActionResult.Value);
        Assert.Equal(bird.Pentad, returnValue.Pentad);

        var birds = await _context.Birds.ToListAsync();
        Assert.Equal(3, birds.Count);
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
        var bird = new Bird { Id = 3, Pentad = "5678", Spp = 2, Common_group = "Group2", Common_species = "Species2", Genus = "Genus2", Species = "Species2" };

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
        Assert.Single(birds);
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
        var birdId = "999";

        // Act
        var result = await _controller.GetBirdsInPentad(birdId);

        // Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

}
