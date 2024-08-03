using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace BeakPeekApi.Models
{
    [Index(nameof(Ref), nameof(Common_species), nameof(Common_group))]
    public class Bird
    {

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Ref { get; set; }

        public string? Common_group { get; set; }

        [Required]
        public required string Common_species { get; set; }

        [Required]
        public required string Genus { get; set; }

        [Required]
        public required string Species { get; set; }

        public double Full_Protocol_RR { get; set; }

        public int Full_Protocol_Number { get; set; }

        [DataType(DataType.DateTime)]
        [Column(TypeName = "Date")]
        public DateTime? Latest_FP { get; set; }

        [JsonIgnore]
        public ICollection<ProvinceList> Bird_Provinces { get; set; }

        [NotMapped]
        [JsonProperty(
                ObjectCreationHandling = ObjectCreationHandling.Replace
                )]
        public IEnumerable<string> Provinces
        {
            get => Bird_Provinces.Select(p => p.Name);
        }

    }

}
