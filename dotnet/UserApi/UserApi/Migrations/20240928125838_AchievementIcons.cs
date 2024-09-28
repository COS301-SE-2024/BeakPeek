using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UserApi.Migrations
{
    /// <inheritdoc />
    public partial class AchievementIcons : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Category",
                schema: "Identity",
                table: "Achievement",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Iconname",
                schema: "Identity",
                table: "Achievement",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Category",
                schema: "Identity",
                table: "Achievement");

            migrationBuilder.DropColumn(
                name: "Iconname",
                schema: "Identity",
                table: "Achievement");
        }
    }
}
