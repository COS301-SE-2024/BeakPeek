using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BeakPeekApi.Migrations
{
    /// <inheritdoc />
    public partial class Images_Automation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Image_url",
                table: "Birds",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Info",
                table: "Birds",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Image_url",
                table: "Birds");

            migrationBuilder.DropColumn(
                name: "Info",
                table: "Birds");
        }
    }
}
