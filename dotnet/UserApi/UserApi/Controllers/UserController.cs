using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using UserApi.Models;

namespace UserApi.Controllers;

[ApiController]
[Route("[controller]/[action]")]
// [Authorize]
[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
// [AllowAnonymous]
public class UserController(UserManager<AppUser> userManager) : ControllerBase
{
    private readonly UserManager<AppUser> _userManager = userManager;

    [HttpGet]
    public async Task<IActionResult> Profile()
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized();

        var user = await GetUser(userId);
        if (user is null)
            return NotFound("User not found.");

        return Ok(user.ToDto());
    }

    private string? GetUserId()
    {
        return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    }
    private async Task<AppUser?> GetUser(string userId)
    {
        return await _userManager.FindByIdAsync(userId);
    }
}
