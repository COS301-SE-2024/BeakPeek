using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UserApi.Migrations
{
    /// <inheritdoc />
    public partial class UserAchievments : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AchievementAppUser",
                schema: "Identity");

            migrationBuilder.AddColumn<int>(
                name: "Level",
                schema: "Identity",
                table: "User",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Lifelist",
                schema: "Identity",
                table: "User",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "UserAchievements",
                schema: "Identity",
                columns: table => new
                {
                    AppUserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    AchievementId = table.Column<int>(type: "int", nullable: false),
                    Progress = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserAchievements", x => new { x.AppUserId, x.AchievementId });
                    table.ForeignKey(
                        name: "FK_UserAchievements_Achievement_AchievementId",
                        column: x => x.AchievementId,
                        principalSchema: "Identity",
                        principalTable: "Achievement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserAchievements_User_AppUserId",
                        column: x => x.AppUserId,
                        principalSchema: "Identity",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserAchievements_AchievementId",
                schema: "Identity",
                table: "UserAchievements",
                column: "AchievementId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserAchievements",
                schema: "Identity");

            migrationBuilder.DropColumn(
                name: "Level",
                schema: "Identity",
                table: "User");

            migrationBuilder.DropColumn(
                name: "Lifelist",
                schema: "Identity",
                table: "User");

            migrationBuilder.CreateTable(
                name: "AchievementAppUser",
                schema: "Identity",
                columns: table => new
                {
                    AchievementsId = table.Column<int>(type: "int", nullable: false),
                    AppUserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AchievementAppUser", x => new { x.AchievementsId, x.AppUserId });
                    table.ForeignKey(
                        name: "FK_AchievementAppUser_Achievement_AchievementsId",
                        column: x => x.AchievementsId,
                        principalSchema: "Identity",
                        principalTable: "Achievement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AchievementAppUser_User_AppUserId",
                        column: x => x.AppUserId,
                        principalSchema: "Identity",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AchievementAppUser_AppUserId",
                schema: "Identity",
                table: "AchievementAppUser",
                column: "AppUserId");
        }
    }
}
