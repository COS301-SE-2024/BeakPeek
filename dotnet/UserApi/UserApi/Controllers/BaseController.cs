using Microsoft.AspNetCore.Mvc;

namespace UserApi.Models;

public abstract class BaseController : Controller
{
    protected IActionResult HandleResponse(object data, string? viewName = null)
    {
        bool accept_json = Request.Headers["Accept"].ToString().Contains("application/json");

        if (accept_json)
        {
            return Ok(data);
        }

        if (viewName is null)
            return View(data);

        return View(viewName, data);
    }
}
