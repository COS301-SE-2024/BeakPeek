using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace BeakPeekApi.Models
{
    /* The main reason for the being a distincion between provinceList
     * and Province is that Province is an abstract class that all of our 
     * Province tables can inherit from therefore Province is used as a 
     * type and not a table however there is still need for a table that
     * has an entity per province and for that entity to have a colleciton
     * of birds
     */
    [Index(nameof(Name), IsUnique = true)]
    public class ProvinceList
    {
        public int Id { get; set; }

        [Required]
        public required string Name { get; set; }

        [JsonIgnore]
        public ICollection<Bird> Province_Birds { get; set; }

        [NotMapped]
        [JsonProperty(
                ObjectCreationHandling = ObjectCreationHandling.Replace
                )]
        public IEnumerable<Bird> Birds
        {
            get => Province_Birds.Select(b => new Bird
            {
                Ref = b.Ref,
                Genus = b.Genus,
                Species = b.Species,
                Common_group = b.Common_group,
                Common_species = b.Common_species
            });
        }
    }
}
