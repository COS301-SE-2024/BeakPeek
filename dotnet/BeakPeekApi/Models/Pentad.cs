using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    [Index(nameof(Pentad_Allocation), IsUnique = true)]
    [Index(nameof(Pentad_Longitude))]
    public class Pentad
    {
        public int Id { get; set; }

        public required string Pentad_Allocation { get; set; }

        // Number before the underscore
        public int Pentad_Longitude { get; set; }

        // Number after the underscore
        public int Pentad_Latitude { get; set; }

        [ForeignKey("ProvinceId")]
        public required ProvinceList Province { get; set; }

        public int Total_Cards { get; set; }

    }


}
