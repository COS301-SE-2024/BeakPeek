using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    // [Index("PentadId", "Bird")]
    public class Province
    {
        public int Id { get; set; }

        // public int PentadId { get; set; }
        // [ForeignKey("Pentad_Allocation")]
        public Pentad? Pentad { get; set; }

        // public int BirdId { get; set; }

        // [ForeignKey("Ref")]
        public int BirdId { get; set; }
        public Bird? Bird { get; set; }

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

    [Table("Easterncape")]
    public class Easterncape : Province { }
    [Table("Freestate")]
    public class Freestate : Province { }
    [Table("Gauteng")]
    public class Gauteng : Province { }
    [Table("Kwazulunatal")]
    public class Kwazulunatal : Province { }
    [Table("Limpopo")]
    public class Limpopo : Province { }
    [Table("Mpumalanga")]
    public class Mpumalanga : Province { }
    [Table("Northerncape")]
    public class Northerncape : Province { }
    [Table("Northwest")]
    public class Northwest : Province { }
    [Table("Westerncape")]
    public class Westerncape : Province { }
}

