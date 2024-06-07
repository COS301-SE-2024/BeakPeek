using Xunit;
using Moq;
using BeakPeekApi.Controllers;
using BeakPeekApi.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Moq.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;

namespace BeakPeekApi.Tests.Controllers
{
    public class GautengBirdSpeciesControllerTests
    {
        private readonly Mock<AppDbContext> _mockContext;
        private readonly GautengBirdSpeciesController _controller;

        public GautengBirdSpeciesControllerTests()
        {
            var data = new List<GautengBirdSpecies>
            {
                new GautengBirdSpecies { Pentad = "1", Genus = "TestGenus1", Common_species = "TestSpecies1" },
                new GautengBirdSpecies { Pentad = "2", Genus = "TestGenus2", Common_species = "TestSpecies2" },
                new GautengBirdSpecies { Pentad = "3", Genus = "TestGenus3", Common_species = "TestSpecies3" },
            }.AsQueryable();

            _mockContext = new Mock<AppDbContext>(new DbContextOptions<AppDbContext>());
            _mockContext.Setup(c => c.GautengBirdSpecies).ReturnsDbSet(data);

            _controller = new GautengBirdSpeciesController(_mockContext.Object);
        }

        [Fact]
        public async Task GetGautengBirdSpecies_ReturnsAllSpecies()
        {
            var result = await _controller.GetGautengBirdSpecies();

            Xunit.Assert.Equal(3, result.Value.Count());
        }


        [Fact]
        public async Task GetGautengBirdSpecies_ReturnsNotFound_WhenIdDoesNotExist()
        {

            _mockContext.Setup(x => x.GautengBirdSpecies.FindAsync(1)).ReturnsAsync((GautengBirdSpecies)null);

            var result = await _controller.GetGautengBirdSpecies(1);

            Assert.IsType<NotFoundResult>(result.Result);

        }

        [Fact]
        public async Task GetGautengBirdSpecies_ReturnsSpecies_WhenIdExists()
        {

            var species = new GautengBirdSpecies { Pentad = "1" };
            _mockContext.Setup(x => x.GautengBirdSpecies.FindAsync(1)).ReturnsAsync(species);

            var result = await _controller.GetGautengBirdSpecies(1);

            Assert.IsType<GautengBirdSpecies>(result.Value);
            Assert.Equal("1", result.Value.Pentad);

        }

        [Fact]
        public async Task PostGautengBirdSpecies_ReturnsSpecies_WhenPosted()
        {

            var species = new GautengBirdSpecies { Pentad = "1" };
            _mockContext.Setup(x => x.GautengBirdSpecies.Add(species));
            _mockContext.Setup(x => x.SaveChangesAsync(default(CancellationToken))).ReturnsAsync(1);

            var result = await _controller.PostGautengBirdSpecies(species);

            var createdAtActionResult = Assert.IsType<CreatedAtActionResult>(result.Result);
            Assert.Equal("GetGautengBirdSpecies", createdAtActionResult.ActionName);
            Assert.Equal(species, createdAtActionResult.Value);
            Assert.Equal(species.Pentad, ((GautengBirdSpecies)createdAtActionResult.Value).Pentad);

        }

        [Fact]
        public async Task DeleteGautengBirdSpecies_ReturnsNoContent_WhenIdExists()
        {
            var species = new GautengBirdSpecies { Pentad = "1" };
            _mockContext.Setup(x => x.GautengBirdSpecies.FindAsync("1")).ReturnsAsync(species);
            _mockContext.Setup(x => x.GautengBirdSpecies.Remove(species));
            _mockContext.Setup(x => x.SaveChangesAsync(default(CancellationToken))).ReturnsAsync(1);

            var result = await _controller.DeleteGautengBirdSpecies("1");

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteGautengBirdSpecies_ReturnsNotFound_WhenIdDoesNotExist()
        {
            _mockContext.Setup(x => x.GautengBirdSpecies.FindAsync("1")).ReturnsAsync((GautengBirdSpecies)null);

            var result = await _controller.DeleteGautengBirdSpecies("1");

            Assert.IsType<NotFoundResult>(result);
        }
    }
}
