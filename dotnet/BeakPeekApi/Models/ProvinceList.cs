using System.ComponentModel.DataAnnotations;

namespace BeakPeekApi.Models
{
    public class ProvinceList
    {
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        public Province provinces { get; set; }
    }
}
