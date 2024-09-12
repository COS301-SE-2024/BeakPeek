using CsvHelper;
using CsvHelper.Configuration;
using CsvHelper.TypeConversion;
using Moq;
using System.Globalization;
using Xunit;
using BeakPeekApi.Helpers;

public class Int32WithCommaConverterTests
{
    private readonly Int32WithCommaConverter _converter;
    private readonly CsvContext _context;

    public Int32WithCommaConverterTests()
    {
        _converter = new Int32WithCommaConverter();
        _context = new CsvContext(new CsvConfiguration(CultureInfo.InvariantCulture));
    }

    [Theory]
    [InlineData("1,234", 1234)]
    [InlineData("1234", 1234)]
    [InlineData("0", 0)]
    [InlineData("", 0)]
    [InlineData(null, 0)]
    [InlineData(" ", 0)]
    public void ConvertFromString_ValidInput_ReturnsExpectedResult(string input, int expected)
    {
        // Arrange
        var readerRowMock = new Mock<IReaderRow>();
        readerRowMock.SetupGet(r => r.Context).Returns(_context);
        var memberMapData = new MemberMapData(null);

        // Act
        var result = _converter.ConvertFromString(input, readerRowMock.Object, memberMapData);

        // Assert
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData("InvalidNumber")]
    [InlineData("123,abc")]
    public void ConvertFromString_InvalidInput_ThrowsTypeConverterException(string input)
    {
        // Arrange
        var readerRowMock = new Mock<IReaderRow>();
        readerRowMock.SetupGet(r => r.Context).Returns(_context);
        var memberMapData = new MemberMapData(null);

        // Act & Assert
        Assert.Throws<TypeConverterException>(() => _converter.ConvertFromString(input, readerRowMock.Object, memberMapData));
    }
}
