using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace BeakPeekApi.Models
{
    public class Bird
    {
        public int Id { get; set; }

        [Key]
        public int Ref { get; set; }

        public string? Common_group { get; set; }

        [Required]
        public string Common_species { get; set; }

        [Required]
        public string Genus { get; set; }

        [Required]
        public string Species { get; set; }

    }

}
