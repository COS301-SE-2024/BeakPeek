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

        public BirdController(AppDbContext context)
        {
            _context = context;
        }

        // Existing methods here...

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
                var birdExists = _context.Birds.Any(e => e.Pentad == id);

                if (!birdExists)
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

        [HttpGet("GetNumBirdByProvince/{province}")]
        public async Task<ActionResult<int>> GetNumBirdsByProvince(string province)
        {
            var provinceID = _context.Provinces.FirstOrDefault(p => p.Name == province);
            if (provinceID == null)
            {
                return NotFound("Province not found");
            }
            var numBirdsInProvince = await _context.Birds
                                            .Where(b => b.ProvinceId == provinceID.Id)
                                            .CountAsync();

            return Ok(numBirdsInProvince);
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
            var birds = await _context.Birds
                .Where(b => b.Common_species == common_species && b.Common_group == common_group)
                .ToListAsync<Bird>();

            if (birds == null || birds.Count() == 0)
            {
                return NotFound("No birds found that match the common species or common group");
            }

            HashSet<string> provinces = new HashSet<string>();
            foreach (Bird bird in birds)
            {
                provinces.Add(bird.Province.Name);
            }

            return Ok(provinces.ToList<string>());
        }
    }
}
