using System.Net;
using System.Net.Http.Json;
using System.Reflection.Metadata.Ecma335;
using BeakPeekApi.Helpers;
using BeakPeekApi.Models;
using Microsoft.Extensions.Configuration;
using Moq;
using Moq.Protected;

public class BirdInfoHelperTest
{
    private readonly Mock<HttpMessageHandler> _httpMessageHandlerMock;
    private readonly HttpClient _httpClient;
    private Mock<IConfigurationSection> _configSectionMock;
    private Mock<IConfiguration> _configMock;
    private readonly BirdInfoHelper _birdInfoHelper;

    public BirdInfoHelperTest()
    {
        _httpMessageHandlerMock = new Mock<HttpMessageHandler>();
        _httpClient = new HttpClient(_httpMessageHandlerMock.Object);
        _configSectionMock = new Mock<IConfigurationSection>();
        _configMock = new Mock<IConfiguration>();

        _configSectionMock
            .Setup(x => x.Value)
            .Returns("your_api_key");
        _configMock
            .Setup(x => x.GetSection("FLICKR_API_KEY"))
            .Returns(_configSectionMock.Object);
        _birdInfoHelper = new BirdInfoHelper(_httpClient, _configMock.Object);
    }

    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsExtract_WhenResponseIsSuccessful()
    {
        var birdName = "sparrow";
        var wikipediaResponse = new WikipediaResponse { Extract = "A small bird." };
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(wikipediaResponse)
        };
        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        //Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);
        Assert.Equal("A small bird.", result);
    }

    [Fact]
    public async Task FetchBirdInfoFromWikipedia_ReturnsNull_WhenResponseIsUnsuccessful()
    {
        // Arrange
        var birdName = "sparrow";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);

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

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);

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

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Act
        var result = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);

        // Assert
        Assert.Null(result);
    }

    /* [Fact]
    public async Task FetchBirdImagesFromFlickr_ReturnsImageList_WhenResponseIsSuccessful()
    {
        // Arrange
        var birdName = "sparrow";
        var flickrResponse = new FlickrResponse
        {
            Photos = new Photos
            {
                Photo = new List<Photo>
                {
                    new Photo { Id = "1", Owner = "owner1", Secret = "secret1", Server = "server1" },
                    new Photo { Id = "2", Owner = "owner2", Secret = "secret2", Server = "server2" }
                }
            }
        };
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(flickrResponse)
        };

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                // ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.Is<HttpRequestMessage>(req => req.RequestUri != null && req.RequestUri.AbsoluteUri.Contains("flickr.photos")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Mock owner info fetching
        //
        var ownerResponseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(new FlickrOwnerResponse { Person = new Person { Username = new Username { _Content = "OwnerName" } } })
        };

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.Is<HttpRequestMessage>(req => req.RequestUri != null && req.RequestUri.AbsoluteUri.Contains("flickr.people.getInfo")),
                // ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(ownerResponseMessage);

        // Act
        var result = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName);

        // Assert
        Assert.Equal(2, result.Count);
        Assert.All(result, img => Assert.Contains("https://live.staticflickr.com", img.Url));
        Assert.All(result, img => Assert.Equal("OwnerName", img.Owner));
    } */

    [Fact]
    public async Task FetchBirdImagesFromFlickr_ReturnsImageList_WhenResponseIsSuccessful()
    {
        // Arrange
        var birdName = "sparrow";
        var flickrResponse = new FlickrResponse
        {
            Photos = new Photos
            {
                Photo = new List<Photo>
            {
                new Photo { Id = "1", ownername = "owner1", Secret = "secret1", Server = "server1" },
                new Photo { Id = "2", ownername = "owner2", Secret = "secret2", Server = "server2" }
            }
            }
        };
        var flickrResponseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(flickrResponse)
        };

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(flickrResponseMessage);

        // Act
        var result = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName);

        Console.WriteLine(result);

        // Assert
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

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Act
        var result = await _birdInfoHelper.FetchOwnerInfoFromFlickr(ownerId);

        // Assert
        Assert.Equal("OwnerName", result);
    }

    [Fact]
    public async Task FetchOwnerInfoFromFlickr_ReturnsUnknown_WhenResponseIsUnsuccessful()
    {
        // Arrange
        var ownerId = "owner1";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);

        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        // Act
        var result = await _birdInfoHelper.FetchOwnerInfoFromFlickr(ownerId);

        // Assert
        Assert.Equal("Unknown", result);
    }
}
