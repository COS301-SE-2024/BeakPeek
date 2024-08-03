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

                // while (csv.Read())
                foreach (var record in bird_list)
                {

                    // var record = csv.GetRecord<Bird_CSV>();

                    bool bird_already_exists = existingBirdRefs.Contains(record.Ref);
                    if (bird_already_exists)
                        continue;


                    bool bird_already_tracked = birds_to_be_added.Any(b => b.Ref == record.Ref);
                    if (bird_already_tracked)
                        continue;


                    // if (record.Common_species == null)
                    //     continue;

                    // if (record.Genus == null)
                    //     continue;

                    // if (record.Species == null)
                    //     continue;


                    Console.WriteLine(record.ToString());

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
                Console.WriteLine("Birds to be added:");
                foreach (var bird in birds_to_be_added)
                {
                    Console.WriteLine($"Ref: {bird.Ref}, Common_species: {bird.Common_species}, Genus: {bird.Genus}, Species: {bird.Species}");
                }
                _context.Birds.AddRange(birds_to_be_added);
                _context.SaveChanges();
            }
        }

        public virtual void ImportCsvData<T>(string filepath, string provinceName) where T : Province, new()
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

                Pentad? tmp_pentad = null;
                List<T> records_to_be_add = new List<T> { };
                HashSet<string> pentads = new HashSet<string>(_context.Pentads.Select(p => p.Pentad_Allocation));
                HashSet<int> birds_in_province = new HashSet<int>(_context.Bird_Provinces.Where(p => p.ProvinceId == province.Id).Select(b => b.BirdId));
                HashSet<int> existing_birds = new HashSet<int>(_context.Birds.Select(b => b.Ref));
                while (csv.Read())
                {
                    var record = csv.GetRecord<Province_Pentad_CSV>();
                    if (record.Pentad != pentad_allocation)
                    {
                        pentad_allocation = record.Pentad;
                        bool does_pentad_exist = pentads.Contains(record.Pentad);
                        Pentad? new_pentad = tmp_pentad;
                        if (does_pentad_exist)
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

                            _context.Pentads.Add(new_pentad);
                            _context.SaveChanges();
                        }
                        tmp_pentad = new_pentad;
                    }

                    bool does_bird_exist = existing_birds.Contains(record.Spp);
                    if (!does_bird_exist)
                    {
                        throw new Exception($"No birds found matching that SPP: {record.Spp}");
                    }

                    var does_bird_have_province = birds_in_province.Contains(record.Spp);

                    if (!does_bird_have_province)
                    {
                        _context.Birds.Find(record.Spp)?.Bird_Provinces.Add(province);
                        _context.SaveChanges();
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

                /* switch (provinceName)
                {
                    case "easterncape":
                        List<Easterncape> Easterncape_list_to_add = (List<Easterncape>)records_to_be_add.Cast<Easterncape>().ToList();
                        _context.Easterncape.AddRange(Easterncape_list_to_add);
                        break;
                    case "freestate":
                        List<Freestate> Freestate_list_to_add = (List<Freestate>)records_to_be_add.Cast<Freestate>().ToList();
                        _context.Freestate.AddRange(Freestate_list_to_add);
                        break;
                    case "gauteng":
                        List<Gauteng> Gauteng_list_to_add = (List<Gauteng>)records_to_be_add.Cast<Gauteng>();
                        _context.Gauteng.AddRange(Gauteng_list_to_add);
                        break;
                    case "kwazulunatal":
                        List<Kwazulunatal> Kwazulunatal_list_to_add = (List<Kwazulunatal>)records_to_be_add.Cast<Kwazulunatal>();
                        _context.Kwazulunatal.AddRange(Kwazulunatal_list_to_add);
                        break;
                    case "limpopo":
                        List<Limpopo> Limpopo_list_to_add = (List<Limpopo>)records_to_be_add.Cast<Limpopo>();
                        _context.Limpopo.AddRange(Limpopo_list_to_add);
                        break;
                    case "mpumalanga":
                        List<Mpumalanga> Mpumalanga_list_to_add = (List<Mpumalanga>)records_to_be_add.Cast<Mpumalanga>();
                        _context.Mpumalanga.AddRange(Mpumalanga_list_to_add);
                        break;
                    case "northerncape":
                        List<Northerncape> Northerncape_list_to_add = (List<Northerncape>)records_to_be_add.Cast<Northerncape>();
                        _context.Northerncape.AddRange(Northerncape_list_to_add);
                        break;
                    case "northwest":
                        List<Northwest> Northwest_list_to_add = (List<Northwest>)records_to_be_add.Cast<Northwest>();
                        _context.Northwest.AddRange(Northwest_list_to_add);
                        break;
                    case "westerncape":
                        List<Westerncape> Westerncape_list_to_add = (List<Westerncape>)records_to_be_add.Cast<Westerncape>();
                        _context.Westerncape.AddRange(Westerncape_list_to_add);
                        break;
                    default:
                        throw new Exception("No province found that matches the province name given.");
                } */

                _context.SaveChanges();
            }
        }

        public virtual void ImportCsvData(string filepath, string provinceName)
        {

            switch (provinceName)
            {
                case "easterncape":
                    ImportCsvData<Easterncape>(filepath, provinceName);
                    break;
                case "freestate":
                    ImportCsvData<Freestate>(filepath, provinceName);
                    break;
                case "gauteng":
                    ImportCsvData<Gauteng>(filepath, provinceName);
                    break;
                case "kwazulunatal":
                    ImportCsvData<Kwazulunatal>(filepath, provinceName);
                    break;
                case "limpopo":
                    ImportCsvData<Limpopo>(filepath, provinceName);
                    break;
                case "mpumalanga":
                    ImportCsvData<Mpumalanga>(filepath, provinceName);
                    break;
                case "northerncape":
                    ImportCsvData<Northerncape>(filepath, provinceName);
                    break;
                case "northwest":
                    ImportCsvData<Northwest>(filepath, provinceName);
                    break;
                case "westerncape":
                    ImportCsvData<Westerncape>(filepath, provinceName);
                    break;
                default:
                    throw new Exception("No province found that matches the province name given.");
            }
            /* var province = _context.ProvincesList.FirstOrDefault(p => p.Name == provinceName);

            if (province == null)
            {
                throw new Exception("province for import does not exist");
            }


            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                csv.Context.RegisterClassMap<Province_Pentad_CSV_Map>();

                string pentad_allocation = String.Empty;

                Pentad? tmp_pentad = null;
                List<Province> records_to_be_add = new List<Province> { };
                HashSet<string> pentads = new HashSet<string>(_context.Pentads.Select(p => p.Pentad_Allocation));
                HashSet<int> birds_in_province = new HashSet<int>(_context.Bird_Provinces.Where(p => p.ProvinceId == province.Id).Select(b => b.BirdId));
                HashSet<int> existing_birds = new HashSet<int>(_context.Birds.Select(b => b.Ref));
                while (csv.Read())
                {
                    var record = csv.GetRecord<Province_Pentad_CSV>();
                    if (record.Pentad != pentad_allocation)
                    {
                        pentad_allocation = record.Pentad;
                        bool does_pentad_exist = pentads.Contains(record.Pentad);
                        Pentad? new_pentad = tmp_pentad;
                        if (does_pentad_exist)
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

                            _context.Pentads.Add(new_pentad);
                            _context.SaveChanges();
                        }
                        tmp_pentad = new_pentad;
                    }

                    bool does_bird_exist = existing_birds.Contains(record.Spp);
                    if (!does_bird_exist)
                    {
                        throw new Exception($"No birds found matching that SPP: {record.Spp}");
                    }

                    var does_bird_have_province = birds_in_province.Contains(record.Spp);

                    if (!does_bird_have_province)
                    {
                        _context.Birds.Find(record.Spp)?.Bird_Provinces.Add(province);
                        _context.SaveChanges();
                    }

                    var bird_record = _context.Birds.Find(record.Spp);

                    Province new_province_entry = new Province
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
                        List<Easterncape> Easterncape_list_to_add = (List<Easterncape>)records_to_be_add.Cast<Easterncape>().ToList();
                        _context.Easterncape.AddRange(Easterncape_list_to_add);
                        break;
                    case "freestate":
                        List<Freestate> Freestate_list_to_add = (List<Freestate>)records_to_be_add.Cast<Freestate>().ToList();
                        _context.Freestate.AddRange(Freestate_list_to_add);
                        break;
                    case "gauteng":
                        List<Gauteng> Gauteng_list_to_add = (List<Gauteng>)records_to_be_add.Cast<Gauteng>();
                        _context.Gauteng.AddRange(Gauteng_list_to_add);
                        break;
                    case "kwazulunatal":
                        List<Kwazulunatal> Kwazulunatal_list_to_add = (List<Kwazulunatal>)records_to_be_add.Cast<Kwazulunatal>();
                        _context.Kwazulunatal.AddRange(Kwazulunatal_list_to_add);
                        break;
                    case "limpopo":
                        List<Limpopo> Limpopo_list_to_add = (List<Limpopo>)records_to_be_add.Cast<Limpopo>();
                        _context.Limpopo.AddRange(Limpopo_list_to_add);
                        break;
                    case "mpumalanga":
                        List<Mpumalanga> Mpumalanga_list_to_add = (List<Mpumalanga>)records_to_be_add.Cast<Mpumalanga>();
                        _context.Mpumalanga.AddRange(Mpumalanga_list_to_add);
                        break;
                    case "northerncape":
                        List<Northerncape> Northerncape_list_to_add = (List<Northerncape>)records_to_be_add.Cast<Northerncape>();
                        _context.Northerncape.AddRange(Northerncape_list_to_add);
                        break;
                    case "northwest":
                        List<Northwest> Northwest_list_to_add = (List<Northwest>)records_to_be_add.Cast<Northwest>();
                        _context.Northwest.AddRange(Northwest_list_to_add);
                        break;
                    case "westerncape":
                        List<Westerncape> Westerncape_list_to_add = (List<Westerncape>)records_to_be_add.Cast<Westerncape>();
                        _context.Westerncape.AddRange(Westerncape_list_to_add);
                        break;
                    default:
                        throw new Exception("No province found that matches the province name given.");
                }

                _context.SaveChanges(); */
            // }
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
            Map(m => m.Total_Records).Index(18).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.Total_Cards).Index(19).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.ReportingRate).Index(20);
        }
    }
}
