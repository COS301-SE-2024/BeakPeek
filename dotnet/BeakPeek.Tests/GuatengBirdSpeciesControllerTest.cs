using Xunit;
using Moq;
using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Controllers;
using BeakPeekApi.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BeakPeekApi.Tests
{
    public class GautengBirdSpeciesControllerTests
    {
        private readonly Mock<DbSet<GautengBirdSpecies>> _mockSet;
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

            _mockSet = new Mock<DbSet<GautengBirdSpecies>>();
            _mockSet.As<IQueryable<GautengBirdSpecies>>().Setup(m => m.Provider).Returns(data.Provider);
            _mockSet.As<IQueryable<GautengBirdSpecies>>().Setup(m => m.Expression).Returns(data.Expression);
            _mockSet.As<IQueryable<GautengBirdSpecies>>().Setup(m => m.ElementType).Returns(data.ElementType);
            _mockSet.As<IQueryable<GautengBirdSpecies>>().Setup(m => m.GetEnumerator()).Returns(data.GetEnumerator());

            _mockContext = new Mock<AppDbContext>();
            _mockContext.Setup(c => c.GautengBirdSpecies).Returns(_mockSet.Object);

            _controller = new GautengBirdSpeciesController(_mockContext.Object);
        }

        [Fact]
        public async Task GetGautengBirdSpecies_ReturnsAllSpecies()
        {
            var result = await _controller.GetGautengBirdSpecies();

            Xunit.Assert.Equal(3, result.Value.Count());
        }

        // Add more tests here for other methods in your controller
    }
}