using System.Security.Claims;
using System.Text.Json;
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
    public async Task<IActionResult> UpdateProfile([FromBody] UserDto updatedUser)
    {

        var userId = GetUserId();
        if (userId is null)
            return Unauthorized();

        // var user = await GetUser(userId);
        var user = await _userManager.FindByIdAsync(userId);
        if (user is null)
            return NotFound("User not found.");


        var setUsernameSuccess = await _userManager.SetUserNameAsync(user, updatedUser.UserName);
        var setEmailSucces = await _userManager.SetEmailAsync(user, updatedUser.Email);
        if (!setEmailSucces.Succeeded || !setUsernameSuccess.Succeeded)
        {
            return BadRequest($"Couldn't update username or email address. ${setEmailSucces.Errors} ${setUsernameSuccess.Errors}");
        }

        user.FromDto(updatedUser);
        var updateResult = await _userManager.UpdateAsync(user);

        if (!updateResult.Succeeded)
        {
            return BadRequest("Error occurred while updating the user.");
        }

        await _userManager.UpdateSecurityStampAsync(user);
        await _signInManager.RefreshSignInAsync(user);
        return Ok(user.ToDto());
    }

    [HttpPost]
    public async Task<IActionResult> AddAchievment(int id, double progress)
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

        var existingUserAchievement = await _context.UserAchievements
            .FirstOrDefaultAsync(ua => ua.AppUserId == userId && ua.AchievementId == id);
        if (existingUserAchievement != null)
        {
            existingUserAchievement.Progress = progress;
            _context.UserAchievements.Update(existingUserAchievement);
            await _context.SaveChangesAsync();
            return Ok("Achievment upated for user");
        }

        var userAchievement = new UserAchievement
        {
            AppUserId = userId,
            AchievementId = id,
            Progress = progress
        };
        _context.UserAchievements.Add(userAchievement);

        await _context.SaveChangesAsync();
        return Ok("Achievment added to user");
    }

    [HttpGet]
    public async Task<IActionResult> GetAchievments()
    {
        var achievements = await _context.Achievement.ToListAsync();

        if (achievements == null || achievements.Count <= 0)
        {
            return NotFound("No achievments found");
        }

        return Ok(achievements);
    }

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> Login(string email, string password)
    {
        var userTryingtoLogin = await _userManager.FindByNameAsync(email) ?? await _userManager.FindByEmailAsync(email);
        if (userTryingtoLogin == null)
        {
            return BadRequest("No user found with that email or username");
        }
        var result = await _signInManager.PasswordSignInAsync(userTryingtoLogin, password, false, lockoutOnFailure: false);

        if (result.Succeeded)
        {
            _logger.LogInformation("User logged in from User Api");

            var user = await _userManager.FindByNameAsync(email) ?? await _userManager.FindByEmailAsync(email);
            if (user is null)
            {
                return BadRequest("Something went wrong user with email not found");
            }
            var token = await _authHandler.GenerateJwtToken(user);
            return Ok(token);
        }

        return Unauthorized($"Bad password or email address ${result}");
    }

    [HttpGet]
    public async Task<IActionResult> Delete()
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized();

        var user = await GetUser(userId);
        if (user is null)
            return NotFound("User not found.");

        string username = user.UserName!;

        var result = await _userManager.DeleteAsync(user);

        if (result.Succeeded)
        {
            return Ok($"User deleted with username: {username}");
        }
        return BadRequest("Something went wrong");
    }



    private string? GetUserId()
    {
        return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    }
    private async Task<AppUser?> GetUser(string userId)
    {
        return await _context.Users
            .Include(a => a.Achievements)
                .ThenInclude(ua => ua.Achievement)
            .FirstOrDefaultAsync(user => user.Id == userId);
        // return await _userManager.FindByIdAsync(userId);
    }
}
