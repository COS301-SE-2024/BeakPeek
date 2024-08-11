using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    [Index(nameof(Pentad_Allocation), IsUnique = true)]
    public class Pentad
    {
        [Key]
        public required string Pentad_Allocation { get; set; }

        // Number before the underscore
        public int Pentad_Longitude { get; set; }

        // Number after the underscore
        public int Pentad_Latitude { get; set; }

        public required ProvinceList Province { get; set; }

        public int Total_Cards { get; set; }

        public PentadDto ToDto()
        {
            return new PentadDto
            {
                Pentad_Allocation = this.Pentad_Allocation,
                Pentad_Longitude = this.Pentad_Longitude,
                Pentad_Latitude = this.Pentad_Latitude,
                Province = this.Province.ToDto(),
                Total_Cards = this.Total_Cards
            };
        }

    }


}
