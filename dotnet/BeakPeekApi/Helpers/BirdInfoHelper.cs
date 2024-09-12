using BeakPeekApi.Models;

namespace BeakPeekApi.Helpers
{

    public class BirdInfoHelper
    {

        private readonly HttpClient _httpClient;
        private readonly string? _flickrApiKey;
        private readonly GeneralHelper _generalHelper;

        public BirdInfoHelper(HttpClient httpClient, IConfiguration config, GeneralHelper generalHelper)
        {
            _generalHelper = generalHelper;
            _flickrApiKey = _generalHelper.getVariableFromEnvOrAppsettings("FLICKR_API_KEY");
            _httpClient = httpClient;
        }

        public async Task<string?> FetchBirdInfoFromWikipedia(string birdName)
        {
            var url = $"https://en.wikipedia.org/api/rest_v1/page/summary/{birdName}";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                return null;
            }

            var content = await response.Content.ReadFromJsonAsync<WikipediaResponse>();
            var wikiResponse = content;

            return wikiResponse?.Extract;
        }

        public async Task<List<BirdImageModel>?> FetchBirdImagesFromFlickr(string birdName)
        {
            var url = $"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key={_flickrApiKey}&text={birdName}&format=json&nojsoncallback=1&per_page=5&extras=owner_name&tags=bird&sort=relevance";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine("Flickr request not successful: " + response);
                return null;
            }

            var content = await response.Content.ReadFromJsonAsync<FlickrResponse>();
            if (content == null)
            {
                Console.WriteLine("No content" + response);
                return null;
            }
            FlickrResponse flickrResponse = content;

            if (flickrResponse?.Photos?.Photo == null)
            {
                return new List<BirdImageModel>();
            }

            var tasks = flickrResponse.Photos.Photo.Select(async p =>
            {
                var ownerInfo = p.ownername;
                return new BirdImageModel
                {
                    Url = $"https://live.staticflickr.com/{p.Server}/{p.Id}_{p.Secret}.jpg",
                    Owner = ownerInfo,
                };
            });

            return (await Task.WhenAll(tasks)).ToList();
        }

        public async Task<string> FetchOwnerInfoFromFlickr(string ownerId)
        {
            var url = $"https://www.flickr.com/services/rest/?method=flickr.people.getInfo&api_key={_flickrApiKey}&user_id={ownerId}&format=json&nojsoncallback=1";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                return "Unknown";
            }

            var content = await response.Content.ReadFromJsonAsync<FlickrOwnerResponse>();

            return content?.Person?.Username?._Content ?? "Unknown";
        }
    }

}

