using System.Net;
using System.Net.Http.Json;
using BeakPeekApi.Helpers;
using BeakPeekApi.Models;
using Moq;

public class BirdInfoHelperTest
{
    private readonly Mock<HttpMessageHandler> _httpMessageHandlerMock;
    private readonly HttpClient _httpClient;
    private readonly BirdInfoHelper _birdInfoHelper;
    private readonly GeneralHelper _generalHelper;

    public BirdInfoHelperTest()
    {
        _httpMessageHandlerMock = new Mock<HttpMessageHandler>();
        _httpClient = new HttpClient(_httpMessageHandlerMock.Object);
        _generalHelper = new GeneralHelper(Mocks.GetConfiguration());

        _birdInfoHelper = new BirdInfoHelper(_httpClient, _generalHelper);
    }

    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsExtract_WhenResponseIsSuccessful()
    {
        var birdName = "sparrow";

        //Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName, Mocks.GetHttpClient());
        Assert.Equal("A small bird.", result);
    }

    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsNull_WhenResponseIsUnsuccessful()
    {
        // Arrange
        var birdName = "sparrow";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName, Mocks.getHttpClientWithResponse(responseMessage));

        // Assert
        Assert.Null(result);
    }


    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsNull_WhenContentIsNull()
    {
        // Arrange
        var birdName = "sparrow";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        { Content = new StringContent("null", System.Text.Encoding.UTF8, "application/json") };

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName, Mocks.getHttpClientWithResponse(responseMessage));

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsNull_WhenExtractIsNull()
    {
        // Arrange
        var birdName = "sparrow";
        var wikipediaResponse = new WikipediaResponse { Extract = null };
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(wikipediaResponse)
        };

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName, Mocks.getHttpClientWithResponse(responseMessage));

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task FetchBirdImagesFromFlickr_ReturnsImageList_WhenResponseIsSuccessful()
    {
        // Arrange
        var birdName = "sparrow";

        // Act
        var result = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName, Mocks.GetHttpClient());

        // Console.WriteLine(result);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(2, result.Count);
        Assert.All(result, img => Assert.Contains("https://live.staticflickr.com", img.Url));
        Assert.All(result, img => Assert.Contains("owner", img.Owner));
    }


    [Fact]
    public async Task FetchOwnerInfoFromFlickr_ReturnsOwnerName_WhenResponseIsSuccessful()
    {
        // Arrange
        var ownerId = "owner1";
        var flickrOwnerResponse = new FlickrOwnerResponse
        {
            Person = new Person { Username = new Username { _Content = "OwnerName" } }
        };
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(flickrOwnerResponse)
        };

        // Act
        var result = await _birdInfoHelper.FetchOwnerInfoFromFlickr(ownerId, Mocks.getHttpClientWithResponse(responseMessage));

        // Assert
        Assert.Equal("OwnerName", result);
    }

    [Fact]
    public async Task FetchOwnerInfoFromFlickr_ReturnsUnknown_WhenResponseIsUnsuccessful()
    {
        // Arrange
        var ownerId = "owner1";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);

        // Act
        var result = await _birdInfoHelper.FetchOwnerInfoFromFlickr(ownerId, Mocks.getHttpClientWithResponse(responseMessage));

        // Assert
        Assert.Equal("Unknown", result);
    }
}
