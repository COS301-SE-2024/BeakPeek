using Microsoft.EntityFrameworkCore;

namespace BeakPeekApi.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<MyTable> MyTables { get; set; }
    }

    public class MyTable
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}

