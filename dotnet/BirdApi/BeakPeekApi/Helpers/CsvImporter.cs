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

        public virtual void ImportBirds(string filepath)
        {
            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                csv.Context.RegisterClassMap<Bird_CSV_Map>();
                List<Bird> birds_to_be_added = new List<Bird> { };
                HashSet<int> existingBirdRefs = new HashSet<int>(_context.Birds.Select(b => b.Ref));

                var bird_list = csv.GetRecords<Bird_CSV>().ToList<Bird_CSV>();

                foreach (var record in bird_list)
                {
                    bool bird_already_exists = existingBirdRefs.Contains(record.Ref);
                    if (bird_already_exists)
                        continue;

                    bool bird_already_tracked = birds_to_be_added.Any(b => b.Ref == record.Ref);
                    if (bird_already_tracked)
                        continue;

                    Bird new_bird = new Bird
                    {
                        Ref = record.Ref,
                        Common_group = record.Common_group,
                        Common_species = record.Common_species,
                        Genus = record.Genus,
                        Species = record.Species,
                        Full_Protocol_RR = record.fp,
                        Full_Protocol_Number = record.fpn,
                        Latest_FP = record.fp_last,
                        Bird_Provinces = new List<ProvinceList> { }

                    };
                    birds_to_be_added.Add(new_bird);
                }
                _context.Birds.AddRange(birds_to_be_added);
                _context.SaveChanges();
            }
        }

        public virtual async Task ImportCsvData<T>(string filepath, string provinceName) where T : Province, new()
        {
            var province = _context.ProvincesList.FirstOrDefault(p => p.Name == provinceName);

            if (province == null)
            {
                throw new Exception($"province for import does not exist {provinceName}");
            }


            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                csv.Context.RegisterClassMap<Province_Pentad_CSV_Map>();

                string pentad_allocation = String.Empty;

                Pentad? tmp_pentad = null;
                List<T> records_to_be_add = new List<T> { };
                HashSet<string> pentads = new HashSet<string>(_context.Pentads.Select(p => p.Pentad_Allocation));
                HashSet<int> birds_in_province = new HashSet<int>(_context.Bird_Provinces.Where(p => p.ProvinceId == province.Id).Select(b => b.BirdId));
                HashSet<int> existing_birds = new HashSet<int>(_context.Birds.Select(b => b.Ref));

                List<Province_Pentad_CSV> provinces_from_csv = csv.GetRecords<Province_Pentad_CSV>().ToList();
                foreach (var record in provinces_from_csv)
                {
                    // var record = csv.GetRecord<Province_Pentad_CSV>();
                    if (record.Pentad != pentad_allocation)
                    {
                        pentad_allocation = record.Pentad;
                        bool does_pentad_exist = pentads.Contains(record.Pentad);
                        Pentad? new_pentad = tmp_pentad;
                        if (!does_pentad_exist)
                        {
                            var long_lat = pentad_allocation.Split("_")?.Select(Int32.Parse)?.ToList();

                            new_pentad = new Pentad
                            {
                                Province = province,
                                Pentad_Allocation = pentad_allocation,
                                Total_Cards = record.Total_Cards,
                                Pentad_Longitude = long_lat[0],
                                Pentad_Latitude = long_lat[1]
                            };

                            pentads.Add(pentad_allocation);

                            await _context.Pentads.AddAsync(new_pentad);
                            await _context.SaveChangesAsync();
                        }
                        tmp_pentad = new_pentad;
                    }

                    bool does_bird_exist = existing_birds.Contains(record.Spp);
                    if (!does_bird_exist)
                    {
                        throw new Exception($"No birds found matching that SPP: {record.Spp}");
                    }

                    bool does_bird_have_province = birds_in_province.Contains(record.Spp);

                    if (!does_bird_have_province)
                    {
                        // await _context.Birds.FindAsync(record.Spp).Bird_Provinces.Add(province);
                        var found_bird = await _context.Birds.FindAsync(record.Spp);
                        if (found_bird != null)
                        {
                            found_bird.Bird_Provinces ??= new List<ProvinceList> { };
                            found_bird.Bird_Provinces.Add(province);
                            await _context.SaveChangesAsync();
                            birds_in_province.Add(record.Spp);
                        }
                    }

                    var bird_record = _context.Birds.Find(record.Spp);

                    T new_province_entry = new T
                    {
                        Pentad = tmp_pentad,
                        Bird = bird_record,
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
                        // List<Easterncape> Easterncape_list_to_add = (List<Easterncape>)records_to_be_add.Cast<Easterncape>().ToList();
                        await _context.Easterncape.AddRangeAsync((IEnumerable<Easterncape>)records_to_be_add);
                        break;
                    case "freestate":
                        // List<Freestate> Freestate_list_to_add = (List<Freestate>)records_to_be_add.Cast<Freestate>().ToList();
                        await _context.Freestate.AddRangeAsync((IEnumerable<Freestate>)records_to_be_add);
                        break;
                    case "gauteng":
                        // List<Gauteng> Gauteng_list_to_add = (List<Gauteng>)records_to_be_add.Cast<Gauteng>();
                        await _context.Gauteng.AddRangeAsync((IEnumerable<Gauteng>)records_to_be_add);
                        break;
                    case "kwazulunatal":
                        // List<Kwazulunatal> Kwazulunatal_list_to_add = (List<Kwazulunatal>)records_to_be_add.Cast<Kwazulunatal>();
                        await _context.Kwazulunatal.AddRangeAsync((IEnumerable<Kwazulunatal>)records_to_be_add);
                        break;
                    case "limpopo":
                        // List<Limpopo> Limpopo_list_to_add = (List<Limpopo>)records_to_be_add.Cast<Limpopo>();
                        await _context.Limpopo.AddRangeAsync((IEnumerable<Limpopo>)records_to_be_add);
                        break;
                    case "mpumalanga":
                        // List<Mpumalanga> Mpumalanga_list_to_add = (List<Mpumalanga>)records_to_be_add.Cast<Mpumalanga>();
                        await _context.Mpumalanga.AddRangeAsync((IEnumerable<Mpumalanga>)records_to_be_add);
                        break;
                    case "northerncape":
                        // List<Northerncape> Northerncape_list_to_add = (List<Northerncape>)records_to_be_add.Cast<Northerncape>();
                        await _context.Northerncape.AddRangeAsync((IEnumerable<Northerncape>)records_to_be_add);
                        break;
                    case "northwest":
                        // List<Northwest> Northwest_list_to_add = (List<Northwest>)records_to_be_add.Cast<Northwest>();
                        await _context.Northwest.AddRangeAsync((IEnumerable<Northwest>)records_to_be_add);
                        break;
                    case "westerncape":
                        // List<Westerncape> Westerncape_list_to_add = (List<Westerncape>)records_to_be_add.Cast<Westerncape>();
                        await _context.Westerncape.AddRangeAsync((IEnumerable<Westerncape>)records_to_be_add);
                        break;
                    default:
                        throw new Exception($"No province found that matches the province name given. {provinceName}");
                }

                await _context.SaveChangesAsync();
            }
        }

        public virtual async Task ImportCsvData(string filepath, string provinceName)
        {

            switch (provinceName)
            {
                case "easterncape":
                    await ImportCsvData<Easterncape>(filepath, provinceName);
                    break;
                case "freestate":
                    await ImportCsvData<Freestate>(filepath, provinceName);
                    break;
                case "gauteng":
                    await ImportCsvData<Gauteng>(filepath, provinceName);
                    break;
                case "kwazulunatal":
                    await ImportCsvData<Kwazulunatal>(filepath, provinceName);
                    break;
                case "limpopo":
                    await ImportCsvData<Limpopo>(filepath, provinceName);
                    break;
                case "mpumalanga":
                    await ImportCsvData<Mpumalanga>(filepath, provinceName);
                    break;
                case "northerncape":
                    await ImportCsvData<Northerncape>(filepath, provinceName);
                    break;
                case "northwest":
                    await ImportCsvData<Northwest>(filepath, provinceName);
                    break;
                case "westerncape":
                    await ImportCsvData<Westerncape>(filepath, provinceName);
                    break;
                default:
                    throw new Exception("No province found that matches the province name given.");
            }
        }

        public async Task ImportAllCsvData(string directoryPath)
        {
            var csvFiles = Directory.GetFiles(directoryPath, "*.csv");
            foreach (var csvFile in csvFiles)
            {
                var province = Path.GetFileNameWithoutExtension(csvFile);
                await ImportCsvData(csvFile, province);
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
        public DateTime fp_last { get; set; }

        public double? ad { get; set; }

        public int? adn { get; set; }

        [Format("yyyy-MM-dd")]
        public DateTime ad_last { get; set; }
    }

    public sealed class Bird_CSV_Map : ClassMap<Bird_CSV>
    {
        public Bird_CSV_Map()
        {
            Map(m => m.Ref).Index(0);
            Map(m => m.Common_group).Index(1);
            Map(m => m.Common_species).Index(2);
            Map(m => m.Genus).Index(3);
            Map(m => m.Species).Index(4);
            Map(m => m.fp).Index(5);
            Map(m => m.fpn).Index(6);
            Map(m => m.fp_last).Index(7);
            Map(m => m.ad).Index(8);
            Map(m => m.adn).Index(9);
            Map(m => m.ad_last).Index(10);
            Map(m => m.fp_last).Default(new DateTime(1, 1, 1), useOnConversionFailure: true);
            Map(m => m.ad_last).Default(new DateTime(1, 1, 1), useOnConversionFailure: true);
        }
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
            Map(m => m.Jan).Index(6);
            Map(m => m.Feb).Index(7);
            Map(m => m.Mar).Index(8);
            Map(m => m.Apr).Index(9);
            Map(m => m.May).Index(10);
            Map(m => m.Jun).Index(11);
            Map(m => m.Jul).Index(12);
            Map(m => m.Aug).Index(13);
            Map(m => m.Sep).Index(14);
            Map(m => m.Oct).Index(15);
            Map(m => m.Nov).Index(16);
            Map(m => m.Dec).Index(17);
            Map(m => m.Total_Records).Index(18).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.Total_Cards).Index(19).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.ReportingRate).Index(20);
        }
    }
}
