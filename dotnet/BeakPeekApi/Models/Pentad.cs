using System.ComponentModel.DataAnnotations.Schema;

namespace BeakPeekApi.Models
{
    public class Pentad
    {
        public int Id { get; set; }
        public required string pentad_hectre { get; set; }

        [ForeignKey("")]
        public required Province province { get; set; }

        public ICollection<Bird> birds { get; set; }
    }


}
