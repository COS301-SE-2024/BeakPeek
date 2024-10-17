using System.Text;
using BeakPeekApi.Helpers;
using BeakPeekApi.Services;

public class BlobStorageSericeTest
{
    private readonly BlobStorageService _blobStorageService;

    private readonly GeneralHelper _generalHelper;

    public BlobStorageSericeTest()
    {
        _generalHelper = new GeneralHelper(Mocks.GetConfiguration());

        _blobStorageService = new BlobStorageService(_generalHelper, Mocks.GetBlobContainerClient("test-container"));
    }

    [Fact]
    public async Task UploadAsync_ReturnsString()
    {
        /// Arrange
        using (var test_stream = new MemoryStream(Encoding.UTF8.GetBytes("some_test_data")))
        {
            var result = await _blobStorageService.UploadImageAsync(test_stream, "test_file.jpg");

            Assert.IsType<string>(result);
            Assert.True(Uri.IsWellFormedUriString(result, UriKind.RelativeOrAbsolute));
            Assert.Equal("https://mockstorage.blob.core.windows.net/test-container/test_file.jpg", result);
        }
    }

    [Theory]
    [InlineData("existing_file", true)]
    [InlineData("not_existing_file", false)]
    public async Task Exists_Returns_False(string filename, bool expected_return)
    {
        /// Arrange
        var result = await _blobStorageService.BlobExistsAsync(filename);

        /// Assert
        Assert.Equal(result, expected_return);
    }

    [Theory]
    [InlineData(".jpg", "image/jpeg")]
    [InlineData(".png", "image/png")]
    [InlineData(".gif", "image/gif")]
    [InlineData(".anythingelse", "application/octet-stream")]
    [InlineData("", "application/octet-stream")]
    public void Check_FileTypes(string file_extension, string expected)
    {
        /// Arrange
        var result = _blobStorageService.GetContentType($"file{file_extension}");

        /// Assert
        Assert.Equal(result, expected);
    }

}
