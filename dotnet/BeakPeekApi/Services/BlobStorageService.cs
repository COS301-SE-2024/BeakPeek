using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using BeakPeekApi.Helpers;

public class BlobStorageService
{
    private readonly string _blobContainerName;
    private readonly BlobContainerClient _blobContainerClient;
    private readonly GeneralHelper _generalHelper;

    public BlobStorageService(IConfiguration configuration, GeneralHelper generalHelper)
    {
        _generalHelper = generalHelper;
        string storageConnectionString = _generalHelper.getVariableFromEnvOrAppsettings(
                "AzureBlobStorage:StorageConnectionString");
        _blobContainerName = _generalHelper.getVariableFromEnvOrAppsettings("AzureBlobStorage:BlobContainerName");
        _blobContainerClient = new BlobContainerClient(storageConnectionString, _blobContainerName);
        _blobContainerClient.CreateIfNotExists(PublicAccessType.Blob);
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

    private string GetContentType(string fileName)
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
