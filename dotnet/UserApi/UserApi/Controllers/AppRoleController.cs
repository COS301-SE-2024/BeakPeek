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

namespace UserApi.Controllers
{
    [ApiController]
    [Authorize(Roles = "SuperAdmin")]
    [Route("[controller]")]
    public class AppRoleController : Controller
    {
        private readonly RoleManager<AppRole> _roleManager;

        public AppRoleController(RoleManager<AppRole> roleManager)
        {
            _roleManager = roleManager;
        }

        // GET: AppRole
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            return View(await _roleManager.Roles.ToListAsync());
        }

        // GET: AppRole/Details/5
        [HttpGet("Details/{id}")]
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appRole = await _roleManager.Roles
                .FirstOrDefaultAsync(m => m.Id == id);
            if (appRole == null)
            {
                return NotFound();
            }

            return View(appRole);
        }

        // GET: AppRole/Create
        [HttpGet("Create")]
        public IActionResult Create()
        {
            return View();
        }

        // POST: AppRole/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost("Create")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(string roleName)
        {
            if (ModelState.IsValid)
            {
                await _roleManager.CreateAsync(new AppRole(roleName.Trim()));
                return RedirectToAction(nameof(Index));
            }
            return View(roleName);
        }

        // GET: AppRole/Edit/5
        [HttpGet("Edit/{roleName}")]
        public async Task<IActionResult> Edit(string roleName)
        {
            if (roleName == null)
            {
                return NotFound();
            }

            var appRole = await _roleManager.FindByNameAsync(roleName);
            if (appRole == null)
            {
                return NotFound();
            }
            return View(appRole);
        }

        // POST: AppRole/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost("Edit/{id}")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("Id,Name,NormalizedName,ConcurrencyStamp")] AppRole appRole)
        {
            if (id != appRole.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await _roleManager.UpdateAsync(appRole);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!await AppRoleExists(appRole.Id))
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
            return View(appRole);
        }

        // GET: AppRole/Delete/5
        [HttpGet("Delete/{roleName}")]
        public async Task<IActionResult> Delete(string roleName)
        {
            if (roleName == null)
            {
                return NotFound();
            }

            var appRole = await _roleManager.FindByNameAsync(roleName);
            if (appRole == null)
            {
                return NotFound();
            }

            return View(appRole);
        }

        // POST: AppRole/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string roleName)
        {
            var appRole = await _roleManager.FindByNameAsync(roleName);
            if (appRole != null)
            {
                await _roleManager.DeleteAsync(appRole);
            }

            return RedirectToAction(nameof(Index));
        }

        private Task<bool> AppRoleExists(string roleName)
        {
            return _roleManager.RoleExistsAsync(roleName);
        }
    }
}
