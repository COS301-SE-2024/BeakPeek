using Enums;
using Microsoft.AspNetCore.Identity;
using UserApi.Models;

public static class ContextSeed
{
    public static async Task SeedRolesAsync(UserManager<AppUser> userManager, RoleManager<AppRole> roleManager)
    {
        foreach (var role in Enum.GetNames(typeof(Roles)))
        {
            // var role_in_db = await roleManager.FindByNameAsync(role);
            // if (role_in_db is null)
            // {
            //     await roleManager.CreateAsync(new AppRole(role));
            // }
            await roleManager.CreateAsync(new AppRole(role));
        }
    }

    public static async Task SeedSuperAdminAsync(UserManager<AppUser> userManager, RoleManager<AppRole> roleManager)
    {

        var defaultUser = new AppUser
        {
            UserName = "superadmin",
            Email = "superadmin@superadmin",
        };
        if (userManager.Users.All(u => u.Id != defaultUser.Id))
        {
            var user = await userManager.FindByEmailAsync(defaultUser.Email);
            if (user == null)
            {
                await userManager.CreateAsync(defaultUser, "SuperAdmin@SuperAdmin1");
                foreach (var role in Enum.GetNames(typeof(Roles)))
                {
                    await userManager.AddToRoleAsync(defaultUser, role);
                }
            }
        }
    }
}
