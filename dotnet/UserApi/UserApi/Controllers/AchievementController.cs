using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using UserApi.Data;
using UserApi.Models;

namespace UserApi.Controllers;

// [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
// [Authorize(AuthenticationSchemes = CookieAuthenticationDefaults.AuthenticationScheme)]
[ApiController]
[Authorize(Roles = "Admin,SuperAdmin")]
[Route("[controller]")]
public class AchievementController : BaseController
{
    private readonly ApplicationDbContext _context;

    public AchievementController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: Achievement
    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var response = await _context.Achievement.ToListAsync();
        return HandleResponse(response);
    }

    // GET: Achievement/Details/5
    [HttpGet("Details/{id}")]
    public async Task<IActionResult> Details(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var achievement = await _context.Achievement
            .FirstOrDefaultAsync(m => m.Id == id);
        if (achievement == null)
        {
            return NotFound();
        }

        return HandleResponse(achievement);
    }

    // GET: Achievement/Create
    [HttpGet("Create")]
    public IActionResult Create()
    {
        return View();
    }

    // POST: Achievement/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost("Create")]
    [ValidateAntiForgeryToken]
    // public async Task<IActionResult> Create([Bind("Id,Name,XP")] Achievement achievement)
    public async Task<IActionResult> Create([FromForm] Achievement achievement)
    {
        if (ModelState.IsValid)
        {
            _context.Add(achievement);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        return HandleResponse(achievement);
    }

    // GET: Achievement/Edit/5
    [HttpGet("Edit/{id}")]
    public async Task<IActionResult> Edit(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var achievement = await _context.Achievement.FindAsync(id);
        if (achievement == null)
        {
            return NotFound();
        }
        return HandleResponse(achievement);
    }

    // POST: Achievement/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost("Edit/{id}")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name,XP")] Achievement achievement)
    {
        if (id != achievement.Id)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            try
            {
                _context.Update(achievement);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AchievementExists(achievement.Id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return RedirectToAction(nameof(Index));
        }
        return HandleResponse(achievement);
    }

    // GET: Achievement/Delete/5
    [HttpGet("Delete/{id}")]
    public async Task<IActionResult> Delete(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var achievement = await _context.Achievement
            .FirstOrDefaultAsync(m => m.Id == id);
        if (achievement == null)
        {
            return NotFound();
        }

        return HandleResponse(achievement);
    }

    // POST: Achievement/Delete/5
    [HttpPost, ActionName("Delete/{id}")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var achievement = await _context.Achievement.FindAsync(id);
        if (achievement != null)
        {
            _context.Achievement.Remove(achievement);
        }

        await _context.SaveChangesAsync();
        return RedirectToAction(nameof(Index));
    }

    private bool AchievementExists(int id)
    {
        return _context.Achievement.Any(e => e.Id == id);
    }
}

