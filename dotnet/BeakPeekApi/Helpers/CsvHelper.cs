using System.Globalization;
using BeakPeekApi.Models;
using CsvHelper;

namespace BeakPeekApi.Helpers
{

    public class Helpers
    {
        public List<Bird> ImportCsvData(string filePath, string source)
        {
            var records = new List<Bird>();

            using (var reader = new StreamReader(filePath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                records = csv.GetRecords<Bird>().ToList<Bird>();
            }
            return records;
        }
    }
}
