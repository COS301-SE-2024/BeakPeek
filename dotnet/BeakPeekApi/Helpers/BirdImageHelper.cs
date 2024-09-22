using BeakPeekApi.Models;
using BeakPeekApi.Services;

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

        public async Task<Bird?> CheckAndAddImage(Bird? bird, HttpClient? httpClient = null)
        {

            if (bird == null)
                return null;

            if (!string.IsNullOrEmpty(bird.Image_url))
            {
                return bird;
            }

            string birdName = bird.Common_species + " " + bird.Common_group;

            var description = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName, httpClient);
            var images = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName, httpClient);

            Console.WriteLine(description);

            if (description == null || images == null || !images.Any())
            {
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

            httpClient = httpClient ?? _httpClient;
            using (httpClient)
            {
                try
                {
                    var response = await httpClient.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    using (var stream = await response.Content.ReadAsStreamAsync())
                    {
                        if (!_dbContext.Birds.Local.Any(e => e.Ref == bird.Ref))
                        {
                            int bird_ref = bird.Ref;
                            bird = await _dbContext.Birds.FindAsync(bird_ref);
                            if (bird is null)
                            {
                                throw new Exception($"No bird matching the given ref({bird_ref}) was found in the datatbase");
                            }
                        }
                        var blobUrl = await _blobStorageService.UploadImageAsync(
                                stream, $"{bird.Ref}_{bird.Common_species}_{bird.Common_group}.jpg");
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

