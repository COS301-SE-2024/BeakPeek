using Microsoft.AspNetCore.Mvc;
using BeakPeekApi.Models;
using BeakPeekApi.Helpers;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BirdInfoController : ControllerBase
    {
        private BirdInfoHelper _birdInfoHelper;

        public BirdInfoController(BirdInfoHelper birdInfoHelper)
        {
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
                return NotFound("Not found");
            }

            return Ok(new BirdInfoModels
            {
                Name = birdName,
                Description = info,
                Images = images
            });
        }
    }
}
