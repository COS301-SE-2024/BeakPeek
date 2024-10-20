using BeakPeekApi.Helpers;
using Microsoft.AspNetCore.Mvc;

namespace BeakPeekApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImportController : ControllerBase
    {
        private readonly CsvImporter _csvImporter;

        public ImportController(CsvImporter csvImporter)
        {
            _csvImporter = csvImporter;
        }

        [HttpPost("import")]
        public async Task<IActionResult> ImportData(IFormFile file, [FromQuery] string province)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("File is empty");
            }

            var filePath = Path.GetTempFileName();
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            await _csvImporter.ImportCsvData(filePath, province);

            return Ok();
        }

        [HttpPost("importAll")]
        public IActionResult ImportAll([FromQuery] string path)
        {
            _csvImporter.ImportAllCsvData(path);

            return Ok();
        }

        [HttpPost("importBirds")]
        public async Task<IActionResult> importBirds(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("File is empty");
            }

            var filePath = Path.GetTempFileName();
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            _csvImporter.ImportBirds(filePath);

            return Ok();
        }
    }
}
