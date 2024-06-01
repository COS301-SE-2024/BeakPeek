using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<GautengBirdSpecies> GautengBirdSpecies { get; set; }
    }
}

