using BeakPeekApi.Models;
using Microsoft.EntityFrameworkCore;

public class DbContextMock
{

    public static AppDbContext GetDbContex()
    {

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        var context = new AppDbContext(options);

        SeedDatabase(context);

        return context;
    }

    public static AppDbContext GetEmptyContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        var context = new AppDbContext(options);

        return context;
    }


    private static void SeedDatabase(AppDbContext context)
    {

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

        List<Pentad> pentads = new List<Pentad> { };

        foreach (ProvinceList province in provinces)
        {
            pentads.Add(new Pentad { Pentad_Allocation = $"{province.Id}_{province.Id}", Province = province, Total_Cards = province.Id, Pentad_Latitude = province.Id, Pentad_Longitude = province.Id });
        }

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

        context.ProvincesList.AddRange(provinces);
        context.SaveChanges();
        context.Birds.AddRange(birds);
        context.SaveChanges();
        context.Pentads.AddRange(pentads);
        context.SaveChanges();
        context.Easterncape.AddRange(provinces_1);
        context.SaveChanges();
        context.Freestate.AddRange(provinces_2);
        context.SaveChanges();
    }
}
