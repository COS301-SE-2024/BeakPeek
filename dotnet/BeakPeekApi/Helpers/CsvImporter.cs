using System.Globalization;
using BeakPeekApi.Models;
using CsvHelper;
using CsvHelper.Configuration;

namespace BeakPeekApi.Helpers
{

    public class CsvImporter
    {
        private readonly AppDbContext _context;

        public CsvImporter(AppDbContext context)
        {
            _context = context;
        }

        public virtual void ImportCsvData(string filepath, string provinceName)
        {
            var province = _context.Provinces.FirstOrDefault(p => p.Name == provinceName);

            if (province == null)
            {
                // Console.WriteLine("Adding new province");
                province = new Province { Name = provinceName };
                _context.Provinces.Add(province);
                _context.SaveChanges();
            }
            else
            {
                // Console.WriteLine($"Province with name: {provinceName}");
            }

            using (var reader = new StreamReader(filepath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                csv.Context.RegisterClassMap<BirdRecordMap>();
                var records = csv.GetRecords<Bird>().ToList();

                foreach (var record in records)
                {
                    record.ProvinceId = province.Id;
                }

                _context.Birds.AddRange(records);
                _context.SaveChanges();
            }
        }

        public virtual void ClearProvinceData(string provinceName)
        {
            var province = _context.Provinces.FirstOrDefault(p => p.Name == provinceName);
            if (province != null)
            {
                var records = _context.Birds.Where(r => r.ProvinceId == province.Id).ToList();
                // Console.WriteLine($"Found {records.Count} records to remove for province: {provinceName}");
                _context.Birds.RemoveRange(records);
                _context.SaveChanges();
                // Console.WriteLine("Records removed and changes saved.");
            }
            else
            {
                // Console.WriteLine($"No province found with name: {provinceName}");
            }
        }

        public virtual void ReplaceProvinceData(string filepath, string provinceName)
        {
            ClearProvinceData(provinceName);
            ImportCsvData(filepath, provinceName);
        }

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

    public sealed class BirdRecordMap : ClassMap<Bird>
    {
        public BirdRecordMap()
        {
            Map(m => m.Pentad).Index(0);
            Map(m => m.Spp).Index(1);
            Map(m => m.Common_group).Index(2);
            Map(m => m.Common_species).Index(3);
            Map(m => m.Genus).Index(4);
            Map(m => m.Species).Index(5);
            Map(m => m.Total_Records).Index(18);
            Map(m => m.Total_Cards).Index(19).TypeConverter<Int32WithCommaConverter>();
            Map(m => m.ReportingRate).Index(20);
            Map(m => m.ProvinceId).Ignore();
            Map(m => m.Province).Ignore();
        }
    }
}
