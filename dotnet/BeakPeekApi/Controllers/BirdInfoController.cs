using Microsoft.AspNetCore.Mvc;
using BeakPeekApi.Models;
using BeakPeekApi.Helpers;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BirdInfoController : ControllerBase
    {
        private readonly AppDbContext _context;
        private BirdInfoHelper _birdInfoHelper;

        public BirdInfoController(AppDbContext context, BirdInfoHelper birdInfoHelper)
        {
            _context = context;
            _birdInfoHelper = birdInfoHelper;
        }

        // Existing methods here...

        [HttpGet("{birdName}")]
        public async Task<ActionResult<BirdInfoModels>> GetBirdInfo(string birdName)
        {
            var info = await _birdInfoHelper.FetchBirdInfoFromWikipedia(birdName);
            var images = await _birdInfoHelper.FetchBirdImagesFromFlickr(birdName);

            if (info == null || images == null || !images.Any())
            {
                return NotFound();
            }

            return new BirdInfoModels
            {
                Name = birdName,
                Description = info,
                Images = images
            };
        }
    }
}
