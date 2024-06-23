using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BeakPeekApi.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GautengBirdSpecies",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Pentad = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Spp = table.Column<int>(type: "int", nullable: false),
                    Common_group = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Common_species = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Genus = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Species = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Jan = table.Column<double>(type: "float", nullable: true),
                    Feb = table.Column<double>(type: "float", nullable: true),
                    Mar = table.Column<double>(type: "float", nullable: true),
                    Apr = table.Column<double>(type: "float", nullable: true),
                    May = table.Column<double>(type: "float", nullable: true),
                    Jun = table.Column<double>(type: "float", nullable: true),
                    Jul = table.Column<double>(type: "float", nullable: true),
                    Aug = table.Column<double>(type: "float", nullable: true),
                    Sep = table.Column<double>(type: "float", nullable: true),
                    Oct = table.Column<double>(type: "float", nullable: true),
                    Nov = table.Column<double>(type: "float", nullable: true),
                    Dec = table.Column<double>(type: "float", nullable: true),
                    Total_Records = table.Column<int>(type: "int", nullable: false),
                    Total_Cards = table.Column<int>(type: "int", nullable: false),
                    ReportingRate = table.Column<double>(type: "float", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GautengBirdSpecies", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Provinces",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Provinces", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Birds",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Pentad = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Spp = table.Column<int>(type: "int", nullable: false),
                    Common_group = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Common_species = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Genus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Species = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ReportingRate = table.Column<double>(type: "float", nullable: false),
                    Total_Records = table.Column<int>(type: "int", nullable: false),
                    Total_Cards = table.Column<int>(type: "int", nullable: false),
                    ProvinceId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Birds", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Birds_Provinces_ProvinceId",
                        column: x => x.ProvinceId,
                        principalTable: "Provinces",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Birds_ProvinceId",
                table: "Birds",
                column: "ProvinceId");

            migrationBuilder.CreateIndex(
                name: "IX_Provinces_Name",
                table: "Provinces",
                column: "Name",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Birds");

            migrationBuilder.DropTable(
                name: "GautengBirdSpecies");

            migrationBuilder.DropTable(
                name: "Provinces");
        }
    }
}
