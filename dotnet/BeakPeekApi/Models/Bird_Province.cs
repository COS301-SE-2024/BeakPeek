using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    [Index(nameof(ProvinceId))]
    public class Bird_Province
    {
        public int BirdId { get; set; }
        public int ProvinceId { get; set; }

        public required Bird Bird { get; set; }
        public required ProvinceList Province { get; set; }
    }
}
