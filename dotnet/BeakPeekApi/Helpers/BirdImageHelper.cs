using BeakPeekApi.Models;

namespace BeakPeekApi.Helpers
{

    public class BirdImageHelper
    {

        private readonly BirdInfoHelper _birdInfoHelper;
        private readonly AppDbContext _dbContext;
        private readonly BlobStorageService _blobStorageService;
        private readonly HttpClient _httpClient;

        public BirdImageHelper(BirdInfoHelper birdInfoHelper, AppDbContext context, HttpClient httpClient, BlobStorageService blobStorageService)
        {
            _birdInfoHelper = birdInfoHelper;
            _dbContext = context;
            _httpClient = httpClient;
            _blobStorageService = blobStorageService;
        }

        public async Task<Bird?> CheckAndAddImage(Bird bird)
        {

            if (bird == null)
                return null;

            if (!string.IsNullOrEmpty(bird.Image_url))
            {
                return bird;
            }

            string birdName = bird.Common_species + " " + bird.Common_group;

            var description = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);
            var images = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName);

            Console.WriteLine(description);

            if (description == null || images == null || !images.Any())
            {
                Console.WriteLine("Something went wrong with the images or description." + images.Any());
                return null;
            }

            BirdInfoModels birdInfo = new BirdInfoModels
            {
                Name = birdName,
                Description = description,
                Images = images
            };

            string url = birdInfo.Images[0].Url;
            string info = birdInfo.Description;

            using (_httpClient)
            {
                try
                {
                    var response = await _httpClient.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    using (var stream = await response.Content.ReadAsStreamAsync())
                    {

                        var blobUrl = await _blobStorageService.UploadImageAsync(
                                stream, $"{bird.Ref}_{bird.Common_species}_{bird.Common_group}.jpg");
                        Console.WriteLine(blobUrl + "\n" + description);
                        bird.Image_url = blobUrl;
                        bird.Info = description;
                        await _dbContext.SaveChangesAsync();
                        return bird;
                    }

                }
                catch (HttpRequestException ex)
                {
                    Console.WriteLine("Failed to download image: " + ex.Message);
                    return null;
                }
            }
        }

    }

}

