#!/bin/bash

# Wait for SQL Server to be available
echo "Waiting for SQL Server to be available..."
until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your_password123 -d master -Q "SELECT 1" &>/dev/null; do
  echo -n "."
  sleep 1
done

echo "SQL Server is up and running"

# Run initial scripts
for f in /docker-entrypoint-initdb.d/*; do
  case "$f" in
    *.sh)  echo "$0: running $f"; . "$f" ;;
    *.sql) echo "$0: running $f"; /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your_password123 -d master -i "$f" ;;
    *)     echo "$0: ignoring $f" ;;
  esac
done

echo "Database initialization and data import completed"

# Keep the container running
tail -f /dev/null
