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
            // the next line below this one is used to get the province entity
            // type by its string name
            // var etype = _context.Model.FindEntityType("BeakPeekApi.Models." + provinceName);

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
            var isUnique = await _context.Birds.Where(b => b.Ref == species.Ref).AnyAsync();

            if (!isUnique)
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

            await _context.Birds.AddAsync(species);

            try
            {
                await _context.SaveChangesAsync();
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
            var species = await _context.Birds.Where(b => b.Ref == id).FirstAsync();
            if (species == null)
            {
                return NotFound("No bird with found matching that Ref");
            }

            _context.Birds.Remove(species);
            await _context.SaveChangesAsync();

            return Ok("Bird deleted succesfully");
        }


        [HttpGet("{pentad}/pentad")]
        public async Task<ActionResult<IEnumerable<Province>>> GetBirdsInPentad(string pentad)
        {

            var pentadResult = await _context.Pentads.Where(p => p.Pentad_Allocation == pentad).FirstOrDefaultAsync();

            if (pentadResult == null)
                return NotFound("No pentads matching that allocation were found");


            var pentadList = new List<Province> { };
            switch (pentadResult.Province.Name.ToLower())
            {
                case "easterncape":
                    return Ok(await _context.Easterncape
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "freestate":
                    return Ok(await _context.Freestate
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "gauteng":
                    return Ok(await _context.Gauteng
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "kwazulunatal":
                    return Ok(await _context.Kwazulunatal
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "limpopo":
                    return Ok(await _context.Limpopo
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "mpumalanga":
                    return Ok(await _context.Mpumalanga
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "northerncape":
                    return Ok(await _context.Northerncape
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "northwest":
                    return Ok(await _context.Northwest
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                case "westerncape":
                    return Ok(await _context.Westerncape
                        .Where(p => p.Pentad == pentadResult)
                        .ToListAsync());
                default:
                    return NotFound("Pentad not found in province.");
            }
        }

        [HttpGet("GetBirdsInProvince/{province}")]
        public async Task<ActionResult<IEnumerable<Bird>>> GetBirdsInProvince(string province)
        {
            var provinceList = await _context.ProvincesList.FirstOrDefaultAsync(p => p.Name == province);
            if (provinceList == null)
            {
                return NotFound("Province not found");
            }

            return Ok(provinceList.Birds);
        }

        [HttpGet("GetNumBirdByProvince/{province}")]
        public async Task<ActionResult<int>> GetNumBirdsByProvince(string province)
        {
            var provinceList = await _context.ProvincesList.FirstOrDefaultAsync(p => p.Name == province);

            if (provinceList == null)
                return NotFound("Province not found");


            return Ok(provinceList.Birds.Count());
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
                .FirstOrDefaultAsync();

            if (bird == null)
            {
                return NotFound("No birds found that match the given common species or common group");
            }

            return Ok(bird.Provinces.Count());
        }

        private Type? GetProvinceTypeByName(string provinceName)
        {
            switch (provinceName.ToLower())
            {
                case "easterncape":
                    return _context.Easterncape.GetType();
                case "freestate":
                    return _context.Freestate.GetType();
                case "gauteng":
                    return _context.Gauteng.GetType();
                case "kwazulunatal":
                    return _context.Kwazulunatal.GetType();
                case "limpopo":
                    return _context.Limpopo.GetType();
                case "mpumalanga":
                    return _context.Mpumalanga.GetType();
                case "northerncape":
                    return _context.Northerncape.GetType();
                case "northwest":
                    return _context.Northwest.GetType();
                case "westerncape":
                    return _context.Westerncape.GetType();
                default:
                    return null;
            }
        }
    }
}
