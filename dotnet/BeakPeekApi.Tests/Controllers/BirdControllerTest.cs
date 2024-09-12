using BeakPeekApi.Controllers;
using BeakPeekApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

public class BirdControllerTest
{
    private readonly AppDbContext _context;
    private readonly BirdController _controller;
    private readonly BirdImageHelper _birdImageHelper;
    private readonly BirdInfoHelper _birdInfoHelper;
    private readonly HttpClient _httpClient;
    private readonly GeneralHelper _generalHelper;

    private readonly BlobStorageService _blobStorageService;

    public BirdControllerTest()
    {
        _context = DbContextMock.GetDbContex();

        _httpClient = Mocks.GetHttpClient();

        _generalHelper = new GeneralHelper(Mocks.GetConfiguration());

        _blobStorageService = new BlobStorageService(_generalHelper, Mocks.GetBlobContainerClient("image-helper-test-container"));

        _birdInfoHelper = new BirdInfoHelper(_httpClient, _generalHelper);
        _birdImageHelper = new BirdImageHelper(_birdInfoHelper, _context, _httpClient, _blobStorageService);
        _controller = new BirdController(_context, _birdImageHelper);

    }

    private void Dispose()
    {
        _context.Dispose();
    }

    [Fact]
    public async Task GetBirds_ReturnsAllBirds()
    {
        // Act
        var result = await _controller.GetBirds();

        Assert.Equal(2, _context.Birds.Include(p => p.Bird_Provinces).Count());
        // Assert

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);
        var returnValue = Assert.IsType<List<BirdDto>>(actionResult.Value);
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
        var actionResult = Assert.IsType<OkObjectResult>(result.Result);
        var returnValue = Assert.IsType<BirdDto>(actionResult.Value);
        Assert.Equal(birdId, returnValue.Ref);
    }

    [Fact]
    public async Task GetBird_ReturnsNotFoundForInvalidId()
    {
        // Arrange
        var birdId = 999;

        // Act
        var result = await _controller.GetBird(birdId);

        // Assert
        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task SearchBirdSpecies_ReturnsMatchingBirds()
    {
        // Act
        var result = await _controller.SearchBirdSpecies("Genus1", "CommonSpecies1");

        // Assert
        var actionResult = Assert.IsType<OkObjectResult>(result.Result);
        var returnValue = Assert.IsType<List<BirdDto>>(actionResult.Value);
        Assert.Single(returnValue);
        Assert.Equal("Genus1", returnValue[0].Genus);
        Assert.Equal("CommonSpecies1", returnValue[0].Common_species);
    }

    [Fact]
    public async Task PostBirds_AddsBirdToContext()
    {
        // Arrange

        var bird = new Bird
        {
            Ref = 7,
            Common_species = "CommonSpecies3",
            Genus = "Genus3",
            Species = "Species3",
            Full_Protocol_Number = 3,
            Full_Protocol_RR = 3.3,
            Bird_Provinces = { },
            Latest_FP = null,
            Common_group = "CommonGroup3"
        };

        // Act
        var result = await _controller.PostBirds(bird);

        // Assert
        var actionResult = Assert.IsType<CreatedAtActionResult>(result.Result);
        var returnValue = Assert.IsType<Bird>(actionResult.Value);
        // var returnValue = Assert.IsType<Bird>(createdAtActionResult.Value);
        Assert.Equal(bird.Ref, returnValue.Ref);

        var birds = await _context.Birds.ToListAsync();
        Assert.Equal(3, birds.Count);
    }

    [Fact]
    public async Task PutBird_UpdatesBirdInContext()
    {
        // Arrange
        var birdId = 2;
        var bird = _context.Birds.First(b => b.Ref == birdId);
        bird.Common_species = "UpdatedSpecies";

        // Act
        var result = await _controller.PutBird(bird.Ref, bird);

        // Assert
        Assert.IsType<OkObjectResult>(result);
        var updatedBird = await _context.Birds.FindAsync(birdId);
        Assert.Equal("UpdatedSpecies", updatedBird?.Common_species);
    }

    [Fact]
    public async Task PutBird_ReturnsBadRequestForMismatchedId()
    {
        // Arrange
        var id = 3;

        var bird = new Bird
        {
            Ref = 6,
            Common_species = "CommonSpecies3",
            Genus = "Genus3",
            Species = "Species3",
            Full_Protocol_Number = 3,
            Full_Protocol_RR = 3.3,
            Bird_Provinces = { },
            Latest_FP = null,
            Common_group = "CommonGroup3"
        };

        // Act
        var result = await _controller.PutBird(id, bird);

        // Assert
        Assert.IsType<BadRequestObjectResult>(result);
    }



    [Fact]
    public async Task GetBirdsByPentad_ReturnsBirdsByPentad()
    {
        // Arrange

        var pentad = "1_1";

        // Act
        var result = await _controller.GetBirdsInPentad(pentad);

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<ProvinceDto>>>(result);
        var okResult = actionResult.Result as OkObjectResult;
        Assert.NotNull(okResult);

        var returnValue = Assert.IsType<List<ProvinceDto>>(okResult.Value);
        Assert.Single(returnValue);
        Assert.Equal(pentad, returnValue[0]?.Pentad?.Pentad_Allocation);
    }



    [Fact]
    public async Task GetBirdsByPentad_ReturnsNotFoundForInvalidPentad()
    {
        // Arrange
        var pentad = "999";

        // Act
        var result = await _controller.GetBirdsInPentad(pentad);

        // Assert
        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task GetBirdsInProvince_ReturnsBirdsInProvince()
    {
        var province = "easterncape";

        // Act
        var result = await _controller.GetBirdsInProvince(province);

        // Assert
        var actionResult = Assert.IsType<ActionResult<IEnumerable<BirdDto>>>(result);
        var okResult = actionResult.Result as OkObjectResult;
        Assert.NotNull(okResult);

        var returnValue = Assert.IsType<List<BirdDto>>(okResult.Value);
        Assert.Equal(1, returnValue.Count());
        Assert.True(returnValue[0]?.Provinces.Contains(province));
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
        string province = "freestate";

        var result = await _controller.GetNumBirdsByProvince(province);

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);
        var objectResult = Assert.IsType<int>(actionResult.Value);

        Assert.Equal(1, objectResult);
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

        Assert.Equal(2, objectResult);
    }

    [Fact]
    public async Task GetBirdProvinces_ReturnsList()
    {
        string common_species = "CommonSpecies2";
        string common_group = "CommonGroup2";
        // string province_1 = "easterncape";
        string province_2 = "freestate";

        var result = await _controller.GetBirdProvinces(common_species, common_group);

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);

        var objectResult = Assert.IsType<List<string>>(actionResult.Value);

        Assert.Equal(1, objectResult.Count());
        // Assert.Contains("easterncape", objectResult);
        Assert.Contains("freestate", objectResult);
        // Assert.Equal(1, objectResult.FindAll(p => p.Equals(province_1)).Count());
        Assert.Equal(1, objectResult.FindAll(p => p.Equals(province_2)).Count());
    }

    [Fact]
    public async Task GetBirdProvinces_ReturnsNotFound()
    {
        string common_species = "no_species";
        string common_group = "no_group";

        var result = await _controller.GetBirdProvinces(common_species, common_group);

        var actionResult = Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task DeleteBird_RemovesBirdFromContext()
    {
        // Arrange
        var birdId = 1;

        // Act
        var result = await _controller.DeleteBird(birdId);

        // Assert
        Assert.IsType<OkObjectResult>(result);
        var birds = await _context.Birds.ToListAsync();
        birds.Count().Equals(2);
    }

    [Fact]
    public async Task DeleteBird_ReturnsNotFoundForInvalidId()
    {
        // Arrange
        var birdId = 999;

        // Act
        var result = await _controller.DeleteBird(birdId);

        // Assert
        Assert.IsType<NotFoundObjectResult>(result);
    }

}
