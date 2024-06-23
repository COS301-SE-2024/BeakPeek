using CsvHelper;
using CsvHelper.Configuration;
using CsvHelper.TypeConversion;
using System.Globalization;

namespace BeakPeekApi.Helpers
{
    public class Int32WithCommaConverter : Int32Converter
    {
        public override object ConvertFromString(string text, IReaderRow row, MemberMapData memberMapData)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return default(int);
            }

            // Remove commas and convert to int
            text = text.Replace(",", "");
            if (int.TryParse(text, NumberStyles.Integer, CultureInfo.InvariantCulture, out int result))
            {
                return result;
            }

            throw new TypeConverterException(this, memberMapData, text, row?.Context, "The conversion cannot be performed.");
        }
    }
}
