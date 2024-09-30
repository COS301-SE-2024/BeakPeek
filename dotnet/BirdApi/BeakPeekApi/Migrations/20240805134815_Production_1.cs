using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace BeakPeekApi.Migrations
{
    /// <inheritdoc />
    public partial class Production_1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateSequence(
                name: "ProvinceSequence");

            migrationBuilder.CreateTable(
                name: "Birds",
                columns: table => new
                {
                    Ref = table.Column<int>(type: "int", nullable: false),
                    Common_group = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    Common_species = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Genus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Species = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Full_Protocol_RR = table.Column<double>(type: "float", nullable: false),
                    Full_Protocol_Number = table.Column<int>(type: "int", nullable: false),
                    Latest_FP = table.Column<DateTime>(type: "Date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Birds", x => x.Ref);
                });

            migrationBuilder.CreateTable(
                name: "ProvincesList",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProvincesList", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Bird_Provinces",
                columns: table => new
                {
                    BirdId = table.Column<int>(type: "int", nullable: false),
                    ProvinceId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bird_Provinces", x => new { x.BirdId, x.ProvinceId });
                    table.ForeignKey(
                        name: "FK_Bird_Provinces_Birds_BirdId",
                        column: x => x.BirdId,
                        principalTable: "Birds",
                        principalColumn: "Ref",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Bird_Provinces_ProvincesList_ProvinceId",
                        column: x => x.ProvinceId,
                        principalTable: "ProvincesList",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Pentads",
                columns: table => new
                {
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Pentad_Longitude = table.Column<int>(type: "int", nullable: false),
                    Pentad_Latitude = table.Column<int>(type: "int", nullable: false),
                    ProvinceId = table.Column<int>(type: "int", nullable: false),
                    Total_Cards = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pentads", x => x.Pentad_Allocation);
                    table.ForeignKey(
                        name: "FK_Pentads_ProvincesList_ProvinceId",
                        column: x => x.ProvinceId,
                        principalTable: "ProvincesList",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Easterncape",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Easterncape", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Easterncape_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Easterncape_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Freestate",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Freestate", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Freestate_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Freestate_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Gauteng",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Gauteng", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Gauteng_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Gauteng_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Kwazulunatal",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kwazulunatal", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Kwazulunatal_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Kwazulunatal_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Limpopo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Limpopo", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Limpopo_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Limpopo_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Mpumalanga",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Mpumalanga", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Mpumalanga_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Mpumalanga_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Northerncape",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Northerncape", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Northerncape_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Northerncape_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Northwest",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Northwest", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Northwest_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Northwest_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Provinces",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Provinces", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Provinces_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Provinces_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.CreateTable(
                name: "Westerncape",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false, defaultValueSql: "NEXT VALUE FOR [ProvinceSequence]"),
                    Pentad_Allocation = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    BirdRef = table.Column<int>(type: "int", nullable: true),
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
                    ReportingRate = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Westerncape", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Westerncape_Birds_BirdRef",
                        column: x => x.BirdRef,
                        principalTable: "Birds",
                        principalColumn: "Ref");
                    table.ForeignKey(
                        name: "FK_Westerncape_Pentads_Pentad_Allocation",
                        column: x => x.Pentad_Allocation,
                        principalTable: "Pentads",
                        principalColumn: "Pentad_Allocation");
                });

            migrationBuilder.InsertData(
                table: "ProvincesList",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "easterncape" },
                    { 2, "freestate" },
                    { 3, "gauteng" },
                    { 4, "kwazulunatal" },
                    { 5, "limpopo" },
                    { 6, "mpumalanga" },
                    { 7, "northerncape" },
                    { 8, "northwest" },
                    { 9, "westerncape" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Bird_Provinces_ProvinceId",
                table: "Bird_Provinces",
                column: "ProvinceId");

            migrationBuilder.CreateIndex(
                name: "IX_Birds_Ref_Common_species_Common_group",
                table: "Birds",
                columns: new[] { "Ref", "Common_species", "Common_group" });

            migrationBuilder.CreateIndex(
                name: "IX_Easterncape_BirdRef",
                table: "Easterncape",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Easterncape_Pentad_Allocation",
                table: "Easterncape",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Freestate_BirdRef",
                table: "Freestate",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Freestate_Pentad_Allocation",
                table: "Freestate",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Gauteng_BirdRef",
                table: "Gauteng",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Gauteng_Pentad_Allocation",
                table: "Gauteng",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Kwazulunatal_BirdRef",
                table: "Kwazulunatal",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Kwazulunatal_Pentad_Allocation",
                table: "Kwazulunatal",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Limpopo_BirdRef",
                table: "Limpopo",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Limpopo_Pentad_Allocation",
                table: "Limpopo",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Mpumalanga_BirdRef",
                table: "Mpumalanga",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Mpumalanga_Pentad_Allocation",
                table: "Mpumalanga",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Northerncape_BirdRef",
                table: "Northerncape",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Northerncape_Pentad_Allocation",
                table: "Northerncape",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Northwest_BirdRef",
                table: "Northwest",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Northwest_Pentad_Allocation",
                table: "Northwest",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_Pentads_Pentad_Allocation",
                table: "Pentads",
                column: "Pentad_Allocation",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Pentads_ProvinceId",
                table: "Pentads",
                column: "ProvinceId");

            migrationBuilder.CreateIndex(
                name: "IX_Provinces_BirdRef",
                table: "Provinces",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Provinces_Pentad_Allocation",
                table: "Provinces",
                column: "Pentad_Allocation");

            migrationBuilder.CreateIndex(
                name: "IX_ProvincesList_Name",
                table: "ProvincesList",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Westerncape_BirdRef",
                table: "Westerncape",
                column: "BirdRef");

            migrationBuilder.CreateIndex(
                name: "IX_Westerncape_Pentad_Allocation",
                table: "Westerncape",
                column: "Pentad_Allocation");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Bird_Provinces");

            migrationBuilder.DropTable(
                name: "Easterncape");

            migrationBuilder.DropTable(
                name: "Freestate");

            migrationBuilder.DropTable(
                name: "Gauteng");

            migrationBuilder.DropTable(
                name: "Kwazulunatal");

            migrationBuilder.DropTable(
                name: "Limpopo");

            migrationBuilder.DropTable(
                name: "Mpumalanga");

            migrationBuilder.DropTable(
                name: "Northerncape");

            migrationBuilder.DropTable(
                name: "Northwest");

            migrationBuilder.DropTable(
                name: "Provinces");

            migrationBuilder.DropTable(
                name: "Westerncape");

            migrationBuilder.DropTable(
                name: "Birds");

            migrationBuilder.DropTable(
                name: "Pentads");

            migrationBuilder.DropTable(
                name: "ProvincesList");

            migrationBuilder.DropSequence(
                name: "ProvinceSequence");
        }
    }
}
