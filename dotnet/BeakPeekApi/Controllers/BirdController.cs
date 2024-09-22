using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Models;
using BeakPeekApi.Helpers;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BirdController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly BirdImageHelper _birdImageHelper;

        public BirdController(AppDbContext context, BirdImageHelper birdImageHelper)
        {
            _context = context;
            _birdImageHelper = birdImageHelper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<BirdDto>>> GetBirds()
        {
            var birds = await _context.Birds
                .Include(b => b.Bird_Provinces)
                .ToListAsync();

            var birdDtos = birds.Select(b => b.ToDto()).ToList();

            if (birdDtos.Count() == 0)
                return NotFound("No Birds were found.");

            return Ok(birdDtos);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BirdDto>> GetBird(int id, HttpClient? httpClient = null)
        {
            var bird = await _context.Birds
                .Include(b => b.Bird_Provinces)
                .FirstOrDefaultAsync(b => b.Ref == id);

            if (bird == null)
            {
                return NotFound("No birds found matching that id.");
            }

            if (string.IsNullOrEmpty(bird.Image_url))
            {
                Bird? bird_with_image = await _birdImageHelper.CheckAndAddImage(bird, httpClient);
                if (bird_with_image != null)
                {
                    bird = bird_with_image;
                }
            }

            return Ok(bird.ToDto());
        }

        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<BirdDto>>> SearchBirdSpecies(string? genus = null, string? commonSpecies = null)
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

            var results = await query.Select(b => b.ToDto()).ToListAsync();

            if (!results.Any())
            {
                return NotFound($"No birds found matching given genus ({genus}) or given common species ({commonSpecies})");
            }
            return Ok(results);
        }

        [HttpPost]
        public async Task<ActionResult<Bird>> PostBirds(Bird species)
        {
            var isUnique = await _context.Birds.FindAsync(species.Ref);

            if (isUnique != null)
            {
                return BadRequest("Bird Ref already exists.");
            }

            await _context.Birds.AddAsync(species);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(PostBirds), new { id = species.Ref }, species);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutBird(int id, Bird species)
        {
            if (id != species.Ref)
            {
                return BadRequest("Id and Ref don not match.");
            }

            var isUnique = await _context.Birds.Where(b => b.Ref == species.Ref).AnyAsync();
            if (!isUnique)
                return BadRequest("Bird ref already exists");

            try
            {
                var is_successful = await _context.SaveChangesAsync();

                if (is_successful > 0)
                    return Ok("Updated Bird Successfully");
            }
            catch (DbUpdateConcurrencyException)
            {
                var birdExists = _context.Birds.Where(b => b.Ref == id).Any();

                if (!birdExists)
                {
                    return NotFound("Bird not found");
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
                return NotFound("No bird with found matching that Ref");
            }

            _context.Birds.Remove(species);
            await _context.SaveChangesAsync();

            return Ok("Bird deleted succesfully");
        }


        [HttpGet("{pentad}/pentad")]
        public async Task<ActionResult<IEnumerable<ProvinceDto>>> GetBirdsInPentad(string pentad)
        {

            var pentadResult = await _context
                .Pentads
                .Include(p => p.Province)
                .Where(p => p.Pentad_Allocation == pentad)
                .FirstOrDefaultAsync();

            if (pentadResult == null)
                return NotFound("No pentads matching that allocation were found");

            var pentadList = new List<Province> { };
            switch (pentadResult.Province.Name.ToLower())
            {
                case "easterncape":
                    return Ok(await _context.Easterncape
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "freestate":
                    return Ok(await _context.Freestate
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "gauteng":
                    return Ok(await _context.Gauteng
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "kwazulunatal":
                    return Ok(await _context.Kwazulunatal
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "limpopo":
                    return Ok(await _context.Limpopo
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "mpumalanga":
                    return Ok(await _context.Mpumalanga
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "northerncape":
                    return Ok(await _context.Northerncape
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "northwest":
                    return Ok(await _context.Northwest
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                case "westerncape":
                    return Ok(await _context.Westerncape
                        .Include(p => p.Bird)
                        .Include(p => p.Pentad)
                        .Where(p => p.Pentad == pentadResult)
                        .Select(p => p.ToDto())
                        .ToListAsync());
                default:
                    return NotFound("Pentad not found in province.");
            }
        }

        [HttpGet("GetBirdsInProvince/{province}")]
        public async Task<ActionResult<IEnumerable<BirdDto>>> GetBirdsInProvince(string province)
        {
            var provinceList = await _context
                .ProvincesList
                .Include(p => p.Province_Birds)
                .FirstOrDefaultAsync(p => p.Name == province);

            if (provinceList == null)
            {
                return NotFound("Province not found");
            }

            return Ok(provinceList.ToDto().Birds);
        }

        [HttpGet("GetNumBirdByProvince/{province}")]
        public async Task<ActionResult<int>> GetNumBirdsByProvince(string province)
        {
            var provinceList = await _context
                .ProvincesList
                .Include(p => p.Province_Birds)
                .FirstOrDefaultAsync(p => p.Name == province);

            if (provinceList == null)
                return NotFound("Province not found");


            return Ok(provinceList.ToDto().Birds.Count());
        }

        [HttpGet("GetNumBirds/{province}")]
        public async Task<ActionResult<int>> GetNumBirds()
        {
            var numBirdsInProvince = await _context.Birds.CountAsync();
            return Ok(numBirdsInProvince);
        }

        [HttpGet("GetBirdProvinces/{common_species}/{common_group}")]
        public async Task<ActionResult<IEnumerable<string>>> GetBirdProvinces(string common_species, string common_group)
        {
            var bird = await _context.Birds
                .Where(b => b.Common_species == common_species && b.Common_group == common_group)
                .Include(b => b.Bird_Provinces)
                .FirstOrDefaultAsync();

            if (bird == null)
            {
                return NotFound("No birds found that match the given common species or common group");
            }

            return Ok(bird.ToDto().Provinces);
        }

        [HttpGet("GetBirdPentads/{id}")]
        public async Task<ActionResult<IEnumerable<ProvinceDto>>> GetBirdsByRef(int id)
        {
            var birds = await _context.Provinces
                .Include(p => p.Bird)
                .Include(p => p.Pentad)
                .Where(p => p.Bird!.Ref == id)
                .ToListAsync();

            if (birds == null || birds.Count == 0)
                return NotFound("No birds matching that reference were found");

            return Ok(birds.Select(p => p.ToDto()).ToList());
        }

    }
}
