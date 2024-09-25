namespace BeakPeekApi.Models
{
    public class BirdInfoModels
    {
        public string Name { get; set; }
        public string? Description { get; set; }
        public List<BirdImageModel>? Images { get; set; }
    }

    public class BirdImageModel
    {
        public string Url { get; set; }
        public string Owner { get; set; }
    }

    public class WikipediaResponse
    {
        public string? Extract { get; set; }
    }

    public class FlickrResponse
    {
        public Photos? Photos { get; set; }
    }

    public class Photos
    {
        public List<Photo>? Photo { get; set; }
    }

    public class Photo
    {
        public string Id { get; set; }

        public string Secret { get; set; }

        public string Server { get; set; }

        public string Owner { get; set; }

        public string ownername { get; set; }
    }

    public class FlickrOwnerResponse
    {
        public Person? Person { get; set; }
    }

    public class Person
    {
        public Username? Username { get; set; }
    }

    public class Username
    {
        public string _Content { get; set; }
    }
}
