using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class Province
    {
        public int Id { get; set; }

        public Pentad? Pentad { get; set; }

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

        public ProvinceDto ToDto()
        {
            return new ProvinceDto
            {
                Id = this.Id,
                Pentad = this.Pentad?.ToDto(),
                Bird = this.Bird?.ToDto(),
                Jan = this.Jan,
                Feb = this.Feb,
                Mar = this.Mar,
                Apr = this.Apr,
                May = this.May,
                Jun = this.Jun,
                Jul = this.Jul,
                Aug = this.Aug,
                Sep = this.Sep,
                Oct = this.Oct,
                Nov = this.Nov,
                Dec = this.Dec,
                Total_Records = this.Total_Records,
                ReportingRate = this.ReportingRate
            };
        }
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

