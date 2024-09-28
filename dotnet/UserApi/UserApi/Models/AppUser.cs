using System.Collections;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;
using NuGet.Protocol.Plugins;

namespace UserApi.Models;

public class AppUser : IdentityUser
{
    [PersonalData]
    public byte[]? ProfilePicture { get; set; }

    [PersonalData]
    public ICollection<UserAchievement> Achievements { get; set; } = [];

    [PersonalData]
    public string Description { get; set; } = "";

    [PersonalData]
    public int XP { get; set; } = 0;

    [PersonalData]
    public int Level { get; set; } = 0;

    [PersonalData]
    public string Lifelist { get; set; } = "";

    public UserDto ToDto()
    {
        return new UserDto
        {
            UserName = UserName,
            Email = Email,
            ProfilePicture = ProfilePicture,
            Achievements = Achievements.Select(a => a.ToDto()).ToList(),
            Description = Description,
            XP = XP,
            Level = Level,
            Lifelist = Lifelist
        };
    }

    public void FromDto(UserDto userDto)
    {
        UserName = userDto.UserName;
        Email = userDto.Email;
        ProfilePicture = userDto.ProfilePicture;
        Description = userDto.Description;
        XP = userDto.XP;
        Level = userDto.Level;
        Lifelist = userDto.Lifelist ?? "";
    }
}

public class UserAchievement
{
    public string AppUserId { get; set; }
    public AppUser User { get; set; }

    public int AchievementId { get; set; }
    public Achievement Achievement { get; set; }

    public double Progress { get; set; }

    public UserAchievementDto ToDto()
    {
        return new UserAchievementDto
        {
            Id = Achievement.Id,
            Progress = Progress
        };
    }
}

public class UserAchievementDto
{
    public int Id { get; set; }
    public double Progress { get; set; }
}

public class UserDto
{
    public string UserName { get; set; }
    public string Email { get; set; }

    public byte[]? ProfilePicture { get; set; }
    public List<UserAchievementDto> Achievements { get; set; }
    public string Description { get; set; }
    public int XP { get; set; }
    public int Level { get; set; }
    public string Lifelist { get; set; } = "";
}
