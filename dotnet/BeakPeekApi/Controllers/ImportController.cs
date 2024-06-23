using BeakPeekApi.Helpers;
using System.Threading.Tasks;
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

            _csvImporter.ImportCsvData(filePath, province);

            return Ok();
        }

        [HttpPost("replace")]
        public async Task<IActionResult> ReplaceData(IFormFile file, [FromQuery] string province)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("File is empty.");
            }

            var filePath = Path.GetTempFileName();
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            _csvImporter.ReplaceProvinceData(filePath, province);

            return Ok();
        }

        [HttpPost("clear")]
        public IActionResult ClearData([FromQuery] string province)
        {
            _csvImporter.ClearProvinceData(province);
            return Ok();
        }
    }
}
