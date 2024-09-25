using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NuGet.Versioning;
using UserApi.Data;
using UserApi.Models;
using UserApi.Services;
using Wangkanai.Extensions;

namespace UserApi.Controllers;

[ApiController]
[Route("[controller]/[action]")]
// [Authorize]
[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
// [AllowAnonymous]
public class UserController : ControllerBase
{
    private readonly UserManager<AppUser> _userManager;
    private readonly ApplicationDbContext _context;
    private readonly SignInManager<AppUser> _signInManager;
    private readonly ILogger<AppUser> _logger;
    private readonly AuthHandler _authHandler;

    public UserController(UserManager<AppUser> userManager, ApplicationDbContext context, SignInManager<AppUser> signInManager, ILogger<AppUser> logger, AuthHandler authHandler)
    {
        _userManager = userManager;
        _context = context;
        _signInManager = signInManager;
        _logger = logger;
        _authHandler = authHandler;
    }

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

    [HttpPost]
    public async Task<IActionResult> AddAchievment(int id)
    {
        var achievement = await _context.Achievement.FindAsync(id);

        if (achievement is null)
        {
            return NotFound("Achievment not found");
        }

        var userId = GetUserId();
        if (userId is null)
            return Unauthorized();

        var user = await GetUser(userId);
        if (user is null)
            return NotFound("User not found");

        if (user.Achievements.Contains(achievement))
            return BadRequest("User already has that achievment");

        user.Achievements.Add(achievement);

        user.XP += achievement.XP;

        await _userManager.UpdateAsync(user);

        return Ok(new { data = user.XP });
    }

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> Login(string email, string password)
    {
        var result = await _signInManager.PasswordSignInAsync(email, password, false, lockoutOnFailure: false);

        if (result.Succeeded)
        {
            _logger.LogInformation("User logged in from User Api");

            var user = await _userManager.FindByEmailAsync(email);
            if (user is null)
            {
                return BadRequest("Something went wrong user with email not found");
            }
            var token = await _authHandler.GenerateJwtToken(user);
            return Ok(token);
        }

        return Unauthorized("Bad password or email address");
    }

    private string? GetUserId()
    {
        return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    }
    private async Task<AppUser?> GetUser(string userId)
    {
        return await _context.Users.Include(a => a.Achievements).FirstOrDefaultAsync(user => user.Id == userId);
        // return await _userManager.FindByIdAsync(userId);
    }
}
