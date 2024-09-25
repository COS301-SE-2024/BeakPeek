using BeakPeekApi.Helpers;
using BeakPeekApi.Models;
using BeakPeekApi.Services;

public class BirdImageHelperTest
{
    private readonly BirdImageHelper _birdImageHelper;
    private readonly BirdInfoHelper _birdInfoHelper;
    private readonly GeneralHelper _generalHelper;
    private readonly BlobStorageService _blobStorageService;

    private readonly HttpClient _httpClient;
    private readonly AppDbContext _context;

    private Bird _untracked_bird = new Bird
    {
        Common_species = "common_species",
        Genus = "genus",
        Species = "species",
        Ref = 9999,
        Info = null,
        Image_url = null,
        Latest_FP = null,
        Common_group = "common_group",
        Bird_Provinces = new List<ProvinceList> { },
        Full_Protocol_RR = 1.1,
        Full_Protocol_Number = 1
    };

    private Bird? _bird;

    public BirdImageHelperTest()
    {
        var configuration = Mocks.GetConfiguration();

        _context = DbContextMock.GetDbContex();

        // _httpClient = new HttpClient(Mock.Of<HttpClientHandler>());
        _httpClient = Mocks.GetHttpClient();
        _generalHelper = new GeneralHelper(configuration);
        _birdInfoHelper = new BirdInfoHelper(_httpClient, _generalHelper);
        _blobStorageService = new BlobStorageService(_generalHelper, Mocks.GetBlobContainerClient("image-helper-test-container"));

        _birdImageHelper = new BirdImageHelper(_birdInfoHelper, _context, _httpClient, _blobStorageService);

        _bird = _context.Birds.Find(1);
        if (_bird is null)
        {
            throw new Exception("Something went wrong when seeding the database");
        }
    }

    [Fact]
    public async Task GetAndAddImage_Null_Bird()
    {
        /// Arrange
        Bird? bird = null;

        /// Act
        var result = await _birdImageHelper.CheckAndAddImage(bird);

        /// Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetAndAddImage_Image_Already_set()
    {
        /// Arrange
        Assert.NotNull(_bird);
        _bird.Image_url = "https://alreadyseturl/image.jpg";
        _bird.Info = "Info";

        /// Act
        var result = await _birdImageHelper.CheckAndAddImage(_bird);

        /// Assert
        Assert.Equal(_bird.Image_url, "https://alreadyseturl/image.jpg");
        Assert.Equal(_bird.Info, "Info");
    }

    [Fact]
    public async Task GetAndAddImage_Image_not_set()
    {
        /// Arrange
        Assert.NotNull(_bird);
        _bird.Image_url = null;
        _bird.Info = null;
        string uri = $"https://mockstorage.blob.core.windows.net/image-helper-test-container/{_bird.Ref}_{_bird.Common_species}_{_bird.Common_group}.jpg";
        string info = "A small bird.";

        /// Act
        // var result = await _birdImageHelper.CheckAndAddImage(_bird, Mocks.GetHttpClientFlickrImages(), Mocks.GetHttpClientWikipediaResponse());

        var result = await _birdImageHelper.CheckAndAddImage(_bird, Mocks.GetHttpClient());

        /// Assert
        Assert.NotNull(result);

        Assert.Equal(_bird.Image_url, uri);
        Assert.Equal(_bird.Info, info);

        Assert.Equal(result.Image_url, uri);
        Assert.Equal(result.Info, info);

        var bird = await _context.Birds.FindAsync(_bird.Ref);

        Assert.NotNull(bird);
        Assert.Equal(bird.Image_url, uri);
        Assert.Equal(bird.Info, info);
    }

    [Fact]
    public async Task GetAndAddImage_Throw_Bird_Not_in_DB()
    {
        /// Arrange
        _untracked_bird.Image_url = null;
        _untracked_bird.Info = null;

        /// Assert
        await Assert.ThrowsAsync<Exception>(async () => await _birdImageHelper.CheckAndAddImage(_untracked_bird, Mocks.GetHttpClient()));
    }

    [Fact]
    public async Task GetAndAddImage_ThrowHttp_Exception()
    {
        /// Arrange
        Assert.NotNull(_bird);
        _bird.Image_url = null;
        _bird.Info = null;

        /// Assert
        var result = await _birdImageHelper.CheckAndAddImage(_bird, Mocks.GetHttpClientThrowException());
        Assert.Null(result);
    }

}
