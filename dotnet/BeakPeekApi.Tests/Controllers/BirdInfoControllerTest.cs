using System.Net;
using System.Net.Http.Json;
using BeakPeekApi.Helpers;
using BeakPeekApi.Models;
using BeakPeekApi.Controllers;
using Moq;
using Moq.Protected;
using Microsoft.AspNetCore.Mvc;

public class BirdInfoControllerTest
{
    private readonly Mock<HttpMessageHandler> _httpMessageHandlerMock;
    private readonly HttpClient _httpClient;
    private readonly BirdInfoHelper _birdInfoHelper;
    private readonly BirdInfoController _birdInfoController;
    private readonly GeneralHelper _generalHelper;

    public BirdInfoControllerTest()
    {

        _httpMessageHandlerMock = new Mock<HttpMessageHandler>();
        _httpClient = new HttpClient(_httpMessageHandlerMock.Object);
        _generalHelper = new GeneralHelper(Mocks.GetConfiguration());

        _birdInfoHelper = new BirdInfoHelper(_httpClient, _generalHelper);

        _birdInfoController = new BirdInfoController(_birdInfoHelper);

    }

    [Fact]
    public async Task GetBirdInfo_ReturnsBirdInfo()
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
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"page/summary/{birdName}")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

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
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"&sort=relevance")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(flickrResponseMessage);

        var result = await _birdInfoController.GetBirdInfo(birdName);

        var actionResult = Assert.IsType<OkObjectResult>(result.Result);

        var objectResult = Assert.IsType<BirdInfoModels>(actionResult.Value);

        Assert.NotNull(objectResult);
        Assert.NotNull(objectResult.Description);
        Assert.NotNull(objectResult.Images);
        objectResult.Description.Equals("A small bird.");
        objectResult.Name.Equals(birdName);
        objectResult.Images.Equals(new List<BirdImageModel>
                {
                new BirdImageModel { Owner = "owner1", Url = $"https://live.staticflickr.com/server1/1_sectret1.jpg" },
                new BirdImageModel { Owner = "owner2", Url = $"https://live.staticflickr.com/server2/2_sectret2.jpg" }
                });
    }

    [Fact]
    public async Task GetBirdInfo_ReturnsNullFromEmptyReponse()
    {

        var birdName = "sparrow";
        var responseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);
        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"page/summary/{birdName}")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

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
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"&sort=relevance")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(flickrResponseMessage);

        var result = await _birdInfoController.GetBirdInfo(birdName);

        var actionResult = Assert.IsType<NotFoundObjectResult>(result.Result);

    }

    [Fact]
    public async Task GetBirdInfo_ReturnsNullFromEmptyReponse_flickr()
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
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"page/summary/{birdName}")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(responseMessage);

        var flickrResponseMessage = new HttpResponseMessage(HttpStatusCode.NotFound);
        _httpMessageHandlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri!.AbsoluteUri.EndsWith($"&sort=relevance")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(flickrResponseMessage);

        var result = await _birdInfoController.GetBirdInfo(birdName);

        var actionResult = Assert.IsType<NotFoundObjectResult>(result.Result);

    }


}
