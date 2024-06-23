using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {

        public virtual DbSet<GautengBirdSpecies> GautengBirdSpecies { get; set; }
        public DbSet<Province> Provinces { get; set; }
        public DbSet<Bird> Birds { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Province>()
                .HasKey(p => p.Id);

            modelBuilder.Entity<Province>()
                .HasIndex(p => p.Name)
                .IsUnique();

            modelBuilder.Entity<Province>()
                .HasMany(p => p.Birds)
                .WithOne(b => b.Province)
                .HasForeignKey(b => b.ProvinceId);

            modelBuilder.Entity<Bird>()
                .HasKey(b => b.Id);

            modelBuilder.Entity<Bird>()
                .HasIndex(b => b.ProvinceId);
        }

    }
}

