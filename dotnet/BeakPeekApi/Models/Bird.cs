

namespace BeakPeekApi.Models
{
    public class Bird
    {
        public int Id { get; set; }
        public string Pentad { get; set; }
        public int Spp { get; set; }
        public string Common_group { get; set; }
        public string Common_species { get; set; }
        public string Genus { get; set; }
        public string Species { get; set; }
        public double ReportingRate { get; set; }
        public int Total_Records { get; set; }
        public int Total_Cards { get; set; }
        public int ProvinceId { get; set; }
        public Province Province { get; set; }

    }

    public class Province
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public ICollection<Bird> Birds { get; set; }
    }
}
