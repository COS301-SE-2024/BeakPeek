namespace UserApi.Models;

public class Achievement
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int XP { get; set; }
    public string Description { get; set; }
    public byte[]? Icon { get; set; }
    public string Category { get; set; }
    public string? Iconname { get; set; }
}
