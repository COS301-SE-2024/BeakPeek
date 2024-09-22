using Microsoft.AspNetCore.Identity;

namespace UserApi.Models;

public class AppUser : IdentityUser
{
    [PersonalData]
    public byte[]? ProfilePicture { get; set; }

    [PersonalData]
    public ICollection<Achievement?>? Achievements { get; set; }
}
