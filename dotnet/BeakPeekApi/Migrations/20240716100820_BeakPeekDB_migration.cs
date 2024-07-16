using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BeakPeekApi.Migrations
{
    /// <inheritdoc />
    public partial class BeakPeekDB_migration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GautengBirdSpecies");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GautengBirdSpecies",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Apr = table.Column<double>(type: "float", nullable: true),
                    Aug = table.Column<double>(type: "float", nullable: true),
                    Common_group = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Common_species = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Dec = table.Column<double>(type: "float", nullable: true),
                    Feb = table.Column<double>(type: "float", nullable: true),
                    Genus = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Jan = table.Column<double>(type: "float", nullable: true),
                    Jul = table.Column<double>(type: "float", nullable: true),
                    Jun = table.Column<double>(type: "float", nullable: true),
                    Mar = table.Column<double>(type: "float", nullable: true),
                    May = table.Column<double>(type: "float", nullable: true),
                    Nov = table.Column<double>(type: "float", nullable: true),
                    Oct = table.Column<double>(type: "float", nullable: true),
                    Pentad = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ReportingRate = table.Column<double>(type: "float", nullable: true),
                    Sep = table.Column<double>(type: "float", nullable: true),
                    Species = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Spp = table.Column<int>(type: "int", nullable: false),
                    Total_Cards = table.Column<int>(type: "int", nullable: false),
                    Total_Records = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GautengBirdSpecies", x => x.id);
                });
        }
    }
}
