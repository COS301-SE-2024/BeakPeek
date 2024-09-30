using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using UserApi.Data;
using UserApi.Models;

namespace UserApi.Controllers;

[ApiController]
[Route("[controller]/[action]")]
[Authorize(Roles = "Admin,SuperAdmin")]
public class AppUserController : BaseController
{
    private readonly ApplicationDbContext _context;
    private readonly UserManager<AppUser> _userManager;

    public AppUserController(ApplicationDbContext context, UserManager<AppUser> userManager)
    {
        _context = context;
        _userManager = userManager;
    }

    // GET: AppUser
    [HttpGet]
    public async Task<IActionResult> Index()
    {
        return View(await _context.Users.ToListAsync());
    }

    // GET: AppUser/Details/5
    [HttpGet]
    public async Task<IActionResult> Details(string id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var appUser = await _context.Users
            .FirstOrDefaultAsync(m => m.Id == id);
        if (appUser == null)
        {
            return NotFound();
        }

        return View(appUser);
    }

    // GET: AppUser/Create
    [HttpGet]
    public IActionResult Create()
    {
        return View();
    }

    // POST: AppUser/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    // public async Task<IActionResult> Create([Bind("ProfilePicture,Id,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount")] AppUser appUser)
    public async Task<IActionResult> Create([FromForm] AppUser appUser)
    {
        if (ModelState.IsValid)
        {
            _context.Add(appUser);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        return View(appUser);
    }

    // GET: AppUser/Edit/5
    [HttpGet]
    public async Task<IActionResult> Edit(string id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var appUser = await _context.Users.FindAsync(id);
        if (appUser == null)
        {
            return NotFound();
        }
        return View(appUser);
    }

    // POST: AppUser/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(string id, [Bind("ProfilePicture,Id,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount")] AppUser appUser)
    {
        if (id != appUser.Id)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            try
            {
                _context.Update(appUser);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AppUserExists(appUser.Id))
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
        return View(appUser);
    }

    // GET: AppUser/Delete/5
    [HttpGet]
    public async Task<IActionResult> Delete(string id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var appUser = await _context.Users
            .FirstOrDefaultAsync(m => m.Id == id);
        if (appUser == null)
        {
            return NotFound();
        }

        return View(appUser);
    }

    // POST: AppUser/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed([FromForm] string Id)
    {
        var appUser = await _userManager.FindByIdAsync(Id);
        if (appUser != null)
        {
            await _userManager.DeleteAsync(appUser);
        }

        return RedirectToAction(nameof(Index));
    }

    private bool AppUserExists(string id)
    {
        return _context.Users.Any(e => e.Id == id);
    }
}

