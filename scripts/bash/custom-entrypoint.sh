#!/bin/bash
# Start SQL Server
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start
sleep 30

# Run the initialization script
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your_password123 -i /docker-entrypoint-initdb.d/init.sql

# Run the data loading script
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your_password123 -i /docker-entrypoint-initdb.d/load_data.sql

# Keep the container running
wait
