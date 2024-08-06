using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

/* The main reason for the being a distincion between provinceList
 * and Province is that Province is an abstract class that all of our 
 * Province tables can inherit from therefore Province is used as a 
 * type and not a table however there is still need for a table that
 * has an entity per province and for that entity to have a colleciton
 * of birds
 */

namespace BeakPeekApi.Models
{

    [Index(nameof(Name), IsUnique = true)]
    public class ProvinceList
    {
        public int Id { get; set; }

        [Required]
        public required string Name { get; set; }

        [JsonIgnore]
        public ICollection<Bird> Province_Birds { get; set; }

        public ProvinceListDto ToDto()
        {
            return new ProvinceListDto
            {
                Id = this.Id,
                Name = this.Name,
                Birds = this.Province_Birds?.Select(b => b.ToDto()).ToList()
            };
        }
    }
}
