using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using BeakPeekApi.Helpers;

namespace BeakPeekApi.Services;
public class BlobStorageService
{
    private readonly BlobContainerClient _blobContainerClient;
    private readonly GeneralHelper _generalHelper;

    public BlobStorageService(
            GeneralHelper generalHelper,
            BlobContainerClient? blobContainerClient = null
            )
    {
        _generalHelper = generalHelper;

        _blobContainerClient = blobContainerClient ?? MakeBlobContainerClient();
    }

    private BlobContainerClient MakeBlobContainerClient()
    {
        string storageConnectionString =
            _generalHelper.getVariableFromEnvOrAppsettings(
                "AzureBlobStorage:StorageConnectionString");
        string blobContainerName =
            _generalHelper.getVariableFromEnvOrAppsettings(
                    "AzureBlobStorage:BlobContainerName");

        var blobContainerClient = new BlobContainerClient(storageConnectionString, blobContainerName);
        blobContainerClient.CreateIfNotExists(PublicAccessType.Blob);
        return blobContainerClient;
    }

    public async Task<string> UploadImageAsync(Stream imageStream, string fileName)
    {

        AccessTier accessTier = AccessTier.Hot;
        var blobClient = _blobContainerClient.GetBlobClient(fileName);
        await blobClient.UploadAsync(imageStream, new BlobUploadOptions
        {
            HttpHeaders = new BlobHttpHeaders { ContentType = GetContentType(fileName) },
            AccessTier = accessTier
        });

        return blobClient.Uri.ToString();
    }

    public async Task<bool> BlobExistsAsync(string fileName)
    {
        var blobClient = _blobContainerClient.GetBlobClient(fileName);
        return await blobClient.ExistsAsync();
    }

    public string GetContentType(string fileName)
    {
        // Simple content type mapping. Extend as needed.
        var extension = Path.GetExtension(fileName).ToLowerInvariant();
        return extension switch
        {
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            _ => "application/octet-stream",
        };
    }
}
