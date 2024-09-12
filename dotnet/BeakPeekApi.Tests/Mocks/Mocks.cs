using System.Net;
using System.Net.Http.Json;
using Azure;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using BeakPeekApi.Models;
using Microsoft.Extensions.Configuration;
using Moq;
using Moq.Protected;

public class Mocks
{
    public static BlobContainerClient GetBlobContainerClient(string container_name = "")
    {
        var mock = new Mock<BlobContainerClient>();

        mock
            .Setup(b => b.Uri)
            .Returns(new Uri("https://mockstorage.blob.core.windows.net"));

        mock
            .Setup(i => i.GetBlobClient(It.IsAny<string>()))
            .Returns((string x) => GetBlobClient(filename: x, container_name: container_name));

        mock
            .Setup(i => i.GetBlobClient("existing_file"))
            .Returns(GetBlobClient());

        mock
            .Setup(i => i.GetBlobClient("not_existing_file"))
            .Returns(GetBlobClient(false));

        return mock.Object;
    }

    public static BlobClient GetBlobClient(bool return_for_exists = true, string filename = "", string container_name = "")
    {
        var mock = new Mock<BlobClient>();

        string uri = "https://mockstorage.blob.core.windows.net";

        uri += (!string.IsNullOrWhiteSpace(container_name)) ? $"/{container_name}" : "";
        uri += (!string.IsNullOrWhiteSpace(filename)) ? $"/{filename}" : "";
        mock
            .Setup(b => b.Uri)
            .Returns(new Uri(uri));

        var blobUploadOptions = new BlobUploadOptions
        {
            HttpHeaders = new BlobHttpHeaders { ContentType = "jpg" },
            AccessTier = AccessTier.Hot
        };

        mock.Setup(x => x.UploadAsync(It.IsAny<Stream>(), true, It.IsAny<CancellationToken>())).Verifiable();

        mock
            .Setup(i => i.ExistsAsync(default(CancellationToken)))
            .ReturnsAsync(Response.FromValue(return_for_exists, new Mock<Response>().Object));

        return mock.Object;
    }

    public static IConfigurationSection GetConfigurationSection()
    {
        var mock = new Mock<IConfigurationSection>();

        mock
            .Setup(x => x.Value)
            .Returns("your_api_key");

        return mock.Object;
    }

    public static IConfiguration GetConfiguration()
    {
        var mock = new Mock<IConfiguration>();


        mock
            .Setup(x => x.GetSection("FLICKR_API_KEY"))
            .Returns(GetConfigurationSection());

        mock
            .Setup(i => i["FLICKR_API_KEY"])
            .Returns("your_api_key");

        mock
            .Setup(i => i["AzureBlobStorage:BlobContainerName"])
            .Returns("azure_connection_string");

        mock
            .Setup(i => i["AzureBlobStorage:StorageConnectionString"])
            .Returns("DefaultEndpointsProtocol=https;AccountName=mockstorage;AccountKey=XXXXX/XXXXXXXXX+XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX+XXX/XX/XXXXX+XXXXXXXXX==;EndpointSuffix=core.windows.net");

        return mock.Object;
    }

    public static HttpClient getHttpClientWithResponse(HttpResponseMessage response)
    {
        var mock = new Mock<HttpClientHandler>();

        mock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(response);

        return new HttpClient(mock.Object);
    }

    public static HttpClient GetHttpClient()
    {


        var wikipediaResponse = new WikipediaResponse { Extract = "A small bird." };
        var responseMessage = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = JsonContent.Create(wikipediaResponse)
        };
        var handlerMock = new Mock<HttpMessageHandler>();

        var response = new HttpResponseMessage(HttpStatusCode.OK);
        response.Content = new StringContent("some_random_content");

        handlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(response);

        handlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri.AbsoluteUri.Contains($"page")),
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

        handlerMock
            .Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.Is<HttpRequestMessage>(m => m.RequestUri.AbsoluteUri.Contains($"&sort=relevance")),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(flickrResponseMessage);



        return new HttpClient(handlerMock.Object);
    }

    public static HttpClient GetHttpClientThrowException()
    {
        var response = new HttpResponseMessage(HttpStatusCode.BadRequest);
        response.Content = new StringContent("some_random_content");

        return getHttpClientWithResponse(response);
    }

}
