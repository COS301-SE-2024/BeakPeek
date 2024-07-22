using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Models;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BirdController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly HttpClient _httpClient;
        private readonly string _flickrApiKey = "FLICKR_API_KEY";

        public BirdController(AppDbContext context, HttpClient httpClient)
        {
            _context = context;
            _httpClient = httpClient;
        }

        // Existing methods here...

        [HttpGet("info/{birdName}")]
        public async Task<ActionResult<BirdInfoDto>> GetBirdInfo(string birdName)
        {
            var info = await FetchBirdInfoFromWikipedia(birdName);
            var images = await FetchBirdImagesFromFlickr(birdName);

            if (info == null || images == null || !images.Any())
            {
                return NotFound();
            }

            return new BirdInfoDto
            {
                Name = birdName,
                Description = info,
                Images = images
            };
        }

        private async Task<string> FetchBirdInfoFromWikipedia(string birdName)
        {
            var url = $"https://en.wikipedia.org/api/rest_v1/page/summary/{birdName}";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                return null;
            }

            var content = await response.Content.ReadAsStringAsync();
            var wikiResponse = JsonConvert.DeserializeObject<WikipediaResponse>(content);

            return wikiResponse?.Extract;
        }

        private async Task<List<BirdImageDto>> FetchBirdImagesFromFlickr(string birdName)
        {
            var url = $"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=FLICKR_API_KEY&text={birdName}&format=json&nojsoncallback=1&per_page=5";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                return null;
            }

            var content = await response.Content.ReadAsStringAsync();
            var flickrResponse = JsonConvert.DeserializeObject<FlickrResponse>(content);

            if (flickrResponse?.Photos?.Photo == null)
            {
                return new List<BirdImageDto>();
            }

            var tasks = flickrResponse.Photos.Photo.Select(async p =>
            {
                var ownerInfo = await FetchOwnerInfoFromFlickr(p.Owner);
                return new BirdImageDto
                {
                    Url = $"https://live.staticflickr.com/{p.Server}/{p.Id}_{p.Secret}.jpg",
                    Owner = ownerInfo
                };
            });

            return (await Task.WhenAll(tasks)).ToList();
        }

        private async Task<string> FetchOwnerInfoFromFlickr(string ownerId)
        {
            var url = $"https://www.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=FLICKR_API_KEY&user_id={ownerId}&format=json&nojsoncallback=1";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
            {
                return "Unknown";
            }

            var content = await response.Content.ReadAsStringAsync();
            var ownerResponse = JsonConvert.DeserializeObject<FlickrOwnerResponse>(content);

            return ownerResponse?.Person?.Username?._Content ?? "Unknown";
        }


        [HttpGet]
        public async Task<ActionResult<IEnumerable<Bird>>> GetBirds()
        {
            return await _context.Birds.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Bird>> GetBird(int id)
        {
            var species = await _context.Birds.FindAsync(id);

            if (species == null)
            {
                return NotFound();
            }

            return species;
        }

        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<Bird>>> SearchBirdSpecies(string genus = null, string commonSpecies = null)
        {
            IQueryable<Bird> query = _context.Birds;

            if (!string.IsNullOrEmpty(genus))
            {
                query = query.Where(b => EF.Functions.Like(b.Genus, $"%{genus}%"));
            }

            if (!string.IsNullOrEmpty(commonSpecies))
            {
                query = query.Where(b => EF.Functions.Like(b.Common_species, $"%{commonSpecies}%"));
            }

            var results = await query.ToListAsync();

            if (!results.Any())
            {
                return NotFound();
            }
            return results;
        }

        [HttpPost]
        public async Task<ActionResult<Bird>> PostBirds(Bird species)
        {
            _context.Birds.Add(species);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetBirds), new { id = species.Pentad }, species);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutBird(string id, Bird species)
        {
            if (id != species.Pentad)
            {
                return BadRequest();
            }

            _context.Entry(species).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!BirdExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBird(int id)
        {
            var species = await _context.Birds.FindAsync(id);
            if (species == null)
            {
                return NotFound();
            }

            _context.Birds.Remove(species);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool BirdExists(string id)
        {
            return _context.Birds.Any(e => e.Pentad == id);
        }

        [HttpGet("{pentad}/pentad")]
        public async Task<ActionResult<IEnumerable<Bird>>> GetBirdsInPentad(string pentad)
        {

            var pentadBirdList = await _context.Birds
                                            .Where(s => s.Pentad == pentad)
                                            .ToListAsync();

            if (pentadBirdList == null || pentadBirdList.Count() == 0)
            {
                return NotFound();
            }

            return Ok(pentadBirdList);
        }

        [HttpGet("GetBirdsInProvince/{province}")]
        public async Task<ActionResult<IEnumerable<Bird>>> GetBirdsInProvince(string province)
        {
            var provinceID = _context.Provinces.FirstOrDefault(p => p.Name == province);
            if (provinceID == null)
            {
                return NotFound("Province not found");
            }
            var provinceBirdList = await _context.Birds
                                            .Where(b => b.ProvinceId == provinceID.Id)
                                            .ToListAsync();

            if (provinceBirdList == null || provinceBirdList.Count() == 0)
            {
                return NotFound();
            }

            return Ok(provinceBirdList);

        }
    }
}
