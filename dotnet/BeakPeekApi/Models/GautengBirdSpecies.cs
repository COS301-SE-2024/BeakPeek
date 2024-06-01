namespace BeakPeekApi.Models
{
    public class GautengBirdSpecies
    {
        public string Pentad { get; set; }
        public int Spp { get; set; }
        public string Common_group { get; set; }
        public string Common_species { get; set; }
        public string Genus { get; set; }
        public string Species { get; set; }
        public decimal Jan { get; set; }
        public decimal Feb { get; set; }
        public decimal Mar { get; set; }
        public decimal Apr { get; set; }
        public decimal May { get; set; }
        public decimal Jun { get; set; }
        public decimal Jul { get; set; }
        public decimal Aug { get; set; }
        public decimal Sep { get; set; }
        public decimal Oct { get; set; }
        public decimal Nov { get; set; }
        public decimal Dec { get; set; }
        public int Total_Records { get; set; }
        public int Total_Cards { get; set; }
        public decimal ReportingRate { get; set; }
        public int id {get; set;}
        // private Guid _id;
        // [Key]
        // public Guid ID
        // {
        //     get { return _id; }
        // }
    }
}
