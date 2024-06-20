using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<GautengBirdSpecies> GautengBirdSpecies { get; set; }


        public DbSet<Bird> Birds { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Bird>()
                .HasKey(e => new { e.Pentad, e.Spp });
        }

    }
}

