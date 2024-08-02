using System.Text;
using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {

        public DbSet<ProvinceList> ProvincesList { get; set; }
        public DbSet<Bird> Birds { get; set; }
        public DbSet<Pentad> Pentads { get; set; }


        public DbSet<Province> Provinces { get; set; }

        public DbSet<Easterncape> Easterncape { get; set; }
        public DbSet<Freestate> Freestate { get; set; }
        public DbSet<Gauteng> Gauteng { get; set; }
        public DbSet<Kwazulunatal> Kwazulunatal { get; set; }
        public DbSet<Limpopo> Limpopo { get; set; }
        public DbSet<Mpumalanga> Mpumalanga { get; set; }
        public DbSet<Northerncape> Northerncape { get; set; }
        public DbSet<Northwest> Northwest { get; set; }
        public DbSet<Westerncape> Westerncape { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder
                .Entity<Province>()
                .UseTpcMappingStrategy();


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

