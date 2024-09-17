namespace BeakPeekApi.Models
{
    public class BirdDto
    {
        public int Ref { get; set; }

        public string? Common_group { get; set; }

        public required string Common_species { get; set; }

        public required string Genus { get; set; }

        public required string Species { get; set; }

        public double Full_Protocol_RR { get; set; }

        public int Full_Protocol_Number { get; set; }

        public DateTime? Latest_FP { get; set; }

        public List<string> Provinces { get; set; }
    }

    public class ProvinceListDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<BirdDto> Birds { get; set; }
    }


    public class ProvinceDto
    {
        public int Id { get; set; }

        public PentadDto? Pentad { get; set; }

        // public int BirdId { get; set; }
        public BirdDto? Bird { get; set; }

        public double? Jan { get; set; }
        public double? Feb { get; set; }
        public double? Mar { get; set; }
        public double? Apr { get; set; }
        public double? May { get; set; }
        public double? Jun { get; set; }
        public double? Jul { get; set; }
        public double? Aug { get; set; }
        public double? Sep { get; set; }
        public double? Oct { get; set; }
        public double? Nov { get; set; }
        public double? Dec { get; set; }


        public int Total_Records { get; set; }

        public double ReportingRate { get; set; }
    }


    public class PentadDto
    {
        public required string Pentad_Allocation { get; set; }

        // Number before the underscore
        public int Pentad_Longitude { get; set; }

        // Number after the underscore
        public int Pentad_Latitude { get; set; }

        public required ProvinceListDto Province { get; set; }

        public int Total_Cards { get; set; }

    }
}
