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
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(options);
        _controller = new BirdController(_context);

        SeedDatabase();
    }

    private void Dispose()
    {
        _context.Dispose();
    }

    private void SeedDatabase()
    {
        // Clear the database
        // _context.Birds.RemoveRange(_context.Birds);
        // _context.Provinces.RemoveRange(_context.Provinces);
        // _context.SaveChanges();

        var provinces = new List<ProvinceList> {
                new ProvinceList { Id = 1, Name = "easterncape", Province_Birds = { } },
                new ProvinceList { Id = 2, Name = "freestate", Province_Birds = { } },
                new ProvinceList { Id = 3, Name = "gauteng", Province_Birds = { } },
                new ProvinceList { Id = 4, Name = "kwazulunatal", Province_Birds = { } },
                new ProvinceList { Id = 5, Name = "limpopo", Province_Birds = { } },
                new ProvinceList { Id = 6, Name = "mpumalanga", Province_Birds = { } },
                new ProvinceList { Id = 7, Name = "northerncape", Province_Birds = { } },
                new ProvinceList { Id = 8, Name = "northwest", Province_Birds = { } },
                new ProvinceList { Id = 9, Name = "westerncape", Province_Birds = { } }
        };

        var pentads = new List<Pentad>
        {
            new Pentad {Pentad_Allocation="1_1", Province = provinces[0], Total_Cards = 1, Pentad_Latitude = 1, Pentad_Longitude = 1 },
            new Pentad {Pentad_Allocation="2_2", Province = provinces[1], Total_Cards = 2, Pentad_Latitude = 2, Pentad_Longitude = 2 }
        };

        var birds = new List<Bird>
        {
            new Bird
            {
                Genus="Genus1",
                Species="Species1",
                Common_group="CommonGroup1",
                Common_species="CommonSpecies1",
                Ref=1,
                Latest_FP=null,
                Bird_Provinces= new List<ProvinceList> {provinces[0]},
                Full_Protocol_RR=1.1,
                Full_Protocol_Number=1
            },

            new Bird
            {
                Genus="Genus2",
                Species="Species2",
                Common_group="CommonGroup2",
                Common_species="CommonSpecies2",
                Ref=2,
                Latest_FP=null,
                Bird_Provinces= new List<ProvinceList> {provinces[1]},
                Full_Protocol_RR=2.2,
                Full_Protocol_Number=2
            },
        };

        var provinces_1 = new List<Easterncape>
        {
            new Easterncape { Pentad = pentads[0], Bird = birds[0],ReportingRate=1.1,Total_Records=1},

            new Easterncape { Pentad = pentads[1], Bird = birds[1],ReportingRate=2.2,Total_Records=2},
        };


        var provinces_2 = new List<Freestate>
        {
            new Freestate { Pentad = pentads[0], Bird = birds[0],ReportingRate=1.1,Total_Records=1},

            new Freestate { Pentad = pentads[1], Bird = birds[1],ReportingRate=2.2,Total_Records=2},
        };



        _context.ProvincesList.AddRange(provinces);
        _context.SaveChanges();
        _context.Birds.AddRange(birds);
        _context.SaveChanges();
        _context.Pentads.AddRange(pentads);
        _context.SaveChanges();
        _context.Easterncape.AddRange(provinces_1);
        _context.SaveChanges();
        _context.Freestate.AddRange(provinces_2);
        _context.SaveChanges();
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
