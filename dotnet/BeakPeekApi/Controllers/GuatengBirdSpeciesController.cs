using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BeakPeekApi.Models;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GautengBirdSpeciesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public GautengBirdSpeciesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<GautengBirdSpecies>>> GetGautengBirdSpecies()
        {
            return await _context.GautengBirdSpecies.ToListAsync();
        }

        [HttpGet("{Genus}")]
        public async Task<ActionResult<GautengBirdSpecies>> GetGautengBirdSpecies(string Genus)
        {
            var species = await _context.GautengBirdSpecies.FindAsync(Genus);

            if (species == null)
            {
                return NotFound();
            }

            return species;
        }

        [HttpPost]
        public async Task<ActionResult<GautengBirdSpecies>> PostGautengBirdSpecies(GautengBirdSpecies species)
        {
            _context.GautengBirdSpecies.Add(species);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetGautengBirdSpecies), new { id = species.Pentad }, species);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutGautengBirdSpecies(string id, GautengBirdSpecies species)
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
                if (!GautengBirdSpeciesExists(id))
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
        public async Task<IActionResult> DeleteGautengBirdSpecies(string id)
        {
            var species = await _context.GautengBirdSpecies.FindAsync(id);
            if (species == null)
            {
                return NotFound();
            }

            _context.GautengBirdSpecies.Remove(species);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool GautengBirdSpeciesExists(string id)
        {
            return _context.GautengBirdSpecies.Any(e => e.Pentad == id);
        }
    }
}
