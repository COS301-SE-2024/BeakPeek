using System.Globalization;
using BeakPeekApi.Models;
using CsvHelper;
using CsvHelper.Configuration;
using CsvHelper.Configuration.Attributes;

namespace BeakPeekApi.Helpers
{

    public class CsvImporter
    {
        private readonly AppDbContext _context;

        public CsvImporter(AppDbContext context)
        {
            _context = context;
        }

        public virtual async void ImportBirds(string filepath)
        {
            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                // csv.Context.RegisterClassMap<Bird_CSV>();
                List<Bird> birds_to_be_added = new List<Bird> { };

                while (csv.Read())
                {
                    var record = csv.GetRecord<Bird_CSV>();

                    var bird_already_exists = await _context.Birds.FindAsync(record.Ref);

                    if (bird_already_exists == null)
                    {
                        Bird new_bird = new Bird
                        {
                            Ref = record.Ref,
                            Common_group = record.Common_group,
                            Common_species = record.Common_species,
                            Genus = record.Genus,
                            Species = record.Species,
                            Full_Protocol_RR = record.fp,
                            Full_Protocol_Number = record.fpn,
                            Latest_FP = record.fpn_last
                        };
                        birds_to_be_added.Add(new_bird);
                    }
                }
                await _context.Birds.AddRangeAsync(birds_to_be_added);
                await _context.SaveChangesAsync();
            }
        }

        public virtual async void ImportCsvData(string filepath, string provinceName)
        {
            var province = _context.ProvincesList.FirstOrDefault(p => p.Name == provinceName);

            if (province == null)
            {
                throw new Exception("province for import does not exist");
            }


            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                csv.Context.RegisterClassMap<Province_Pentad_CSV_Map>();

                string pentad_allocation = String.Empty;

                Pentad tmp_pentad = null;
                List<Province> records_to_be_add = new List<Province> { };
                while (csv.Read())
                {
                    var record = csv.GetRecord<Province_Pentad_CSV>();
                    if (record.Pentad != pentad_allocation)
                    {
                        pentad_allocation = record.Pentad;
                        var does_pentad_exist = await _context.Pentads.FindAsync(pentad_allocation);
                        if (does_pentad_exist == null)
                        {
                            var long_lat = pentad_allocation.Split("_")?.Select(Int32.Parse)?.ToList();

                            does_pentad_exist = new Pentad
                            {
                                Province = province,
                                Pentad_Allocation = pentad_allocation,
                                Total_Cards = record.Total_Cards,
                                Pentad_Longitude = long_lat[0],
                                Pentad_Latitude = long_lat[1]
                            };

                            await _context.Pentads.AddAsync(does_pentad_exist);
                            await _context.SaveChangesAsync();
                        }
                        tmp_pentad = does_pentad_exist;
                    }

                    var does_bird_exist = await _context.Birds.FindAsync(record.Spp);
                    if (does_bird_exist == null)
                    {
                        throw new Exception("No birds found matching that SPP");
                    }

                    if (does_bird_exist.Bird_Provinces.FirstOrDefault(b => b == province) == null)
                    {
                        does_bird_exist.Bird_Provinces.Add(province);
                        await _context.SaveChangesAsync();
                    }

                    Province new_province_entry = new Province
                    {
                        Pentad = tmp_pentad,
                        Bird = does_bird_exist,
                        Jan = record.Jan,
                        Feb = record.Feb,
                        Mar = record.Mar,
                        Apr = record.Apr,
                        May = record.May,
                        Jun = record.Jun,
                        Jul = record.Jul,
                        Aug = record.Aug,
                        Sep = record.Sep,
                        Oct = record.Oct,
                        Nov = record.Nov,
                        Dec = record.Dec,
                        ReportingRate = record.ReportingRate,
                        Total_Records = record.Total_Records,
                    };

                    records_to_be_add.Add(new_province_entry);

                }

                switch (provinceName)
                {
                    case "easterncape":
                        await _context.Easterncape.AddRangeAsync(records_to_be_add.Cast<Easterncape>().ToList());
                        break;
                    case "freestate":
                        await _context.Freestate.AddRangeAsync(records_to_be_add.Cast<Freestate>().ToList());
                        break;
                    case "gauteng":
                        await _context.Gauteng.AddRangeAsync(records_to_be_add.Cast<Gauteng>().ToList());
                        break;
                    case "kwazulunatal":
                        await _context.Kwazulunatal.AddRangeAsync(records_to_be_add.Cast<Kwazulunatal>().ToList());
                        break;
                    case "limpopo":
                        await _context.Limpopo.AddRangeAsync(records_to_be_add.Cast<Limpopo>().ToList());
                        break;
                    case "mpumalanga":
                        await _context.Mpumalanga.AddRangeAsync(records_to_be_add.Cast<Mpumalanga>().ToList());
                        break;
                    case "northerncape":
                        await _context.Northerncape.AddRangeAsync(records_to_be_add.Cast<Northerncape>().ToList());
                        break;
                    case "northwest":
                        await _context.Northwest.AddRangeAsync(records_to_be_add.Cast<Northwest>().ToList());
                        break;
                    case "westerncape":
                        await _context.Westerncape.AddRangeAsync(records_to_be_add.Cast<Westerncape>().ToList());
                        break;
                    default:
                        throw new Exception("No province found that matches the province name given.");
                }

                await _context.SaveChangesAsync();
            }
        }

        // public virtual void ClearProvinceData(string provinceName)
        // {
        //     var province = _context.Provinces.FirstOrDefault(p => p.Name == provinceName);
        //     if (province != null)
        //     {
        //         var records = _context.Birds.Where(r => r.ProvinceId == province.Id).ToList();
        //         // Console.WriteLine($"Found {records.Count} records to remove for province: {provinceName}");
        //         _context.Birds.RemoveRange(records);
        //         _context.SaveChanges();
        //         // Console.WriteLine("Records removed and changes saved.");
        //     }
        //     else
        //     {
        //         // Console.WriteLine($"No province found with name: {provinceName}");
        //     }
        // }

        // public virtual void ReplaceProvinceData(string filepath, string provinceName)
        // {
        //     ClearProvinceData(provinceName);
        //     ImportCsvData(filepath, provinceName);
        // }

        public void ImportAllCsvData(string directoryPath)
        {
            var csvFiles = Directory.GetFiles(directoryPath, "*.csv");
            foreach (var csvFile in csvFiles)
            {
                var province = Path.GetFileNameWithoutExtension(csvFile);
                ImportCsvData(csvFile, province);
            }
        }
    }

    public class Bird_CSV
    {
        public int Ref { get; set; }

        public string? Common_group { get; set; }

        public required string Common_species { get; set; }

        public required string Genus { get; set; }

        public required string Species { get; set; }

        public double fp { get; set; }

        public int fpn { get; set; }

        [Format("yyyy-MM-dd")]
        public DateTime fpn_last { get; set; }

        public double ad { get; set; }

        public int adn { get; set; }

        [Format("yyyy-MM-dd")]
        public DateTime ad_last { get; set; }
    }

    public class Province_Pentad_CSV
    {
        public string Pentad { get; set; }
        public int Spp { get; set; }
        public string Common_group { get; set; }
        public string Common_species { get; set; }
        public string Genus { get; set; }
        public string Species { get; set; }
        public double? Jan { get; set; }
        public double? Feb { get; set; }
        public double? Mar { get; set; }
        public double? Apr { get; set; }
        public double? May { get; set; }
        public double? Jun { get; set; }
        public double? Jul { get; set; }
        public double? Aug { get; set; }
        public double? Sep { get; set; }
        public double? Oct { get; set; }
        public double? Nov { get; set; }
        public double? Dec { get; set; }
        public int Total_Records { get; set; }
        public int Total_Cards { get; set; }
        public double ReportingRate { get; set; }
    }

    public sealed class Province_Pentad_CSV_Map : ClassMap<Province_Pentad_CSV>
    {
        public Province_Pentad_CSV_Map()
        {
            Map(m => m.Pentad).Index(0);
            Map(m => m.Spp).Index(1);
            Map(m => m.Common_group).Index(2);
            Map(m => m.Common_species).Index(3);
            Map(m => m.Genus).Index(4);
            Map(m => m.Species).Index(5);
            Map(m => m.Total_Records).Index(18).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.Total_Cards).Index(19).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.ReportingRate).Index(20);
        }
    }
}
