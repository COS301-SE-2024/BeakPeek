using Newtonsoft.Json;
using System.Collections.Generic;

namespace BeakPeekApi.Models
{
    public class BirdInfoDto
    {
        public string Name { get; set; }
        public string? Description { get; set; }
        public List<BirdImageDto>? Images { get; set; }
    }

    public class BirdImageDto
    {
        public string Url { get; set; }
        public string Owner { get; set; }
    }

    public class WikipediaResponse
    {
        [JsonProperty("extract")]
        public string? Extract { get; set; }
    }

    public class FlickrResponse
    {
        [JsonProperty("photos")]
        public Photos? Photos { get; set; }
    }

    public class Photos
    {
        [JsonProperty("photo")]
        public List<Photo>? Photo { get; set; }
    }

    public class Photo
    {
        [JsonProperty("id")]
        public string Id { get; set; }

        [JsonProperty("secret")]
        public string Secret { get; set; }

        [JsonProperty("server")]
        public string Server { get; set; }

        [JsonProperty("owner")]
        public string Owner { get; set; }
    }

    public class FlickrOwnerResponse
    {
        [JsonProperty("person")]
        public Person? Person { get; set; }
    }

    public class Person
    {
        [JsonProperty("username")]
        public Username? Username { get; set; }
    }

    public class Username
    {
        [JsonProperty("_content")]
        public string _Content { get; set; }
    }
}
