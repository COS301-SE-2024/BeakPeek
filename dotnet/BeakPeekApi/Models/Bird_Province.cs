using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    [Index(nameof(ProvinceId))]
    public class Bird_Province
    {
        public int BirdId { get; set; }
        public int ProvinceId { get; set; }
    }
}
