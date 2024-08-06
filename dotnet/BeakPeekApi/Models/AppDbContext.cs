using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {

        public DbSet<ProvinceList> ProvincesList { get; set; }
        public DbSet<Bird> Birds { get; set; }
        public DbSet<Bird_Province> Bird_Provinces { get; set; }

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
                .Entity<ProvinceList>()
                .HasData(
                new ProvinceList { Id = 1, Name = "easterncape", Province_Birds = { } },
                new ProvinceList { Id = 2, Name = "freestate", Province_Birds = { } },
                new ProvinceList { Id = 3, Name = "gauteng", Province_Birds = { } },
                new ProvinceList { Id = 4, Name = "kwazulunatal", Province_Birds = { } },
                new ProvinceList { Id = 5, Name = "limpopo", Province_Birds = { } },
                new ProvinceList { Id = 6, Name = "mpumalanga", Province_Birds = { } },
                new ProvinceList { Id = 7, Name = "northerncape", Province_Birds = { } },
                new ProvinceList { Id = 8, Name = "northwest", Province_Birds = { } },
                new ProvinceList { Id = 9, Name = "westerncape", Province_Birds = { } });

            modelBuilder
                .Entity<Province>()
                .UseTpcMappingStrategy();

            modelBuilder
                .Entity<Pentad>()
                .HasOne(p => p.Province)
                .WithMany()
                .HasForeignKey("ProvinceId")
                .IsRequired();


            modelBuilder
                .Entity<Bird>()
                .HasMany(b => b.Bird_Provinces)
                .WithMany(p => p.Province_Birds)
                .UsingEntity<Bird_Province>(
                        l => l.HasOne<ProvinceList>().WithMany().HasForeignKey(e => e.ProvinceId),
                        r => r.HasOne<Bird>().WithMany().HasForeignKey(e => e.BirdId)
                        );

            modelBuilder
                .Entity<ProvinceList>()
                .HasMany(p => p.Province_Birds)
                .WithMany(b => b.Bird_Provinces)
                .UsingEntity<Bird_Province>(
                        l => l.HasOne<Bird>().WithMany().HasForeignKey(e => e.BirdId),
                        r => r.HasOne<ProvinceList>().WithMany().HasForeignKey(e => e.ProvinceId)
                        );

        }

    }
}

