using System.Collections;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace UserApi.Models;

public class AppUser : IdentityUser
{
    [PersonalData]
    public byte[]? ProfilePicture { get; set; }

    [PersonalData]
    public ICollection<Achievement> Achievements { get; set; } = [];

    [PersonalData]
    public string Description { get; set; } = "";

    [PersonalData]
    public int XP { get; set; } = 0;

    public UserDto ToDto()
    {
        return new UserDto
        {
            UserName = UserName,
            Email = Email,
            ProfilePicture = ProfilePicture,
            Achievements = Achievements.ToList(),
            Description = Description,
            XP = XP
        };
    }
}

public class UserDto
{
    public string UserName { get; set; }
    public string Email { get; set; }

    public byte[]? ProfilePicture { get; set; }
    public List<Achievement> Achievements { get; set; }
    public string Description { get; set; }
    public int XP { get; set; }
}
