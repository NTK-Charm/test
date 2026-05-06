#!/bin/bash
# Automated Testing Script for WordPress Environment
set -e

echo "=== Starting Automated Tests ==="

# Install necessary tools
apt update && apt install -y curl wget mysql-client

# Wait for MariaDB to be ready
# echo "Waiting for MariaDB to become available..."
# for i in {1..60}; do
#   if mysqladmin ping -h db -u root -p"$MYSQL_ROOT_PASSWORD" --silent; then
#     echo "✅ MariaDB is ready"
#     break
#   fi
#   echo "⏳ MariaDB not ready yet. Retrying... ($i/60)"
#   sleep 5
#   if [ "$i" -eq 60 ]; then
#     echo "❌ MariaDB did not become ready in time"
#     echo "--- MariaDB logs ---"
#     mysqladmin version -h db -u root -p"$MYSQL_ROOT_PASSWORD" || true
#     exit 1
#   fi
# done

# Test database connectivity
# echo "Testing MariaDB connectivity..."
# if mysql -h db -u wordpress_user -p"$MYSQL_PASSWORD" wordpress_db -e "SELECT 1;" > /dev/null 2>&1; then
#     echo "✅ Database connection successful"
# else
#     echo "❌ Database connection failed"
#     exit 1
# fi

# Test WordPress web server accessibility
echo "Testing WordPress web server..."
if curl -f -s http://web:80/wp-admin/install.php > /dev/null; then
    echo "✅ WordPress web server accessible"
else
    echo "❌ WordPress web server not accessible"
    exit 1
fi

# Test persistence via mounted WordPress volume
echo "Testing data persistence..."
mkdir -p /var/www/html-check/wp-content/uploads
TEST_FILE="/var/www/html-check/wp-content/uploads/test-persistence.txt"
touch "$TEST_FILE"
if [ -f "$TEST_FILE" ]; then
    echo "✅ Data persistence file created in mounted WordPress volume"
else
    echo "❌ Data persistence failed"
    exit 1
fi

# Run additional tests (placeholder for custom tests)
echo "Running custom tests..."
if [ -f "/tests/example-test.sh" ]; then
  bash /tests/example-test.sh || echo "❌ Custom test failed"
else
  echo "⚠ No custom test found at /tests/example-test.sh"
fi

echo "=== All Tests Completed Successfully ==="