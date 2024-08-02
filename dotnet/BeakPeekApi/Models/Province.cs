using System.ComponentModel.DataAnnotations.Schema;

namespace BeakPeekApi.Models
{
    public abstract class Province
    {
        public int Id { get; set; }
        public string Name { get; set; }

        [ForeignKey("Id")]
        public Pentad pentad { get; set; }
        public Bird bird { get; set; }

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
        public int Total_Cards { get; set; }

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

