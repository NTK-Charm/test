#!/bin/bash
# Verify Docker Setup & Connectivity Script

set -e

echo "=== Verifying Docker Setup & Connectivity ==="

if [ -f .env ]; then
  echo "Loading environment variables from .env"
  set -o allexport
  source .env
  set +o allexport
else
  echo "❌ .env file not found. Create it from .env.example or inject secrets."
  exit 1
fi

# Check running containers
echo "Checking running containers..."
docker-compose ps

# Wait for MariaDB health
echo "Waiting for MariaDB to become healthy..."
for i in {1..30}; do
  if docker-compose exec -T db mysqladmin ping -u root -p"$MYSQL_ROOT_PASSWORD" --silent; then
    echo "✅ MariaDB is healthy"
    break
  fi
  echo "⏳ Waiting for MariaDB... ($i/30)"
  sleep 5
  if [ "$i" -eq 30 ]; then
    echo "❌ MariaDB did not become healthy in time"
    exit 1
  fi
done

# Test database connectivity
echo "Testing MariaDB connectivity..."
docker-compose exec -T db mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"

# Test WordPress database connection
echo "Testing WordPress database connection..."
docker-compose exec -T db mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 'Database connection successful' as status;"

# Test WordPress web accessibility
echo "Testing WordPress web server..."
curl -I http://localhost:8080

# Test data persistence
echo "Testing data persistence..."
docker-compose exec -T web ls -la /var/www/html/wp-content/uploads || echo "Uploads directory not yet created"

echo "=== Verification Complete ==="
echo "If all tests pass, WordPress should be accessible at http://localhost:8080"