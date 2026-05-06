# Setup Local Testing Server with Docker Runner

## Recommended Approach: Docker Runner for Automated Testing

Sử dụng Docker Runner để chạy các test tự động trong môi trường container hóa, đảm bảo tính nhất quán và dễ dàng tích hợp với CI/CD pipeline.

### Prerequisites

1. **Install Docker Desktop** trên Windows:
   - Download từ https://www.docker.com/products/docker-desktop
   - Cài đặt và đảm bảo Docker daemon đang chạy

### Docker Runner Configuration

Docker Compose đã được cấu hình với service `test-runner`:

```yaml
test-runner:
  image: ubuntu:20.04
  volumes:
    - ./tests:/tests
    - ./scripts:/scripts
  working_dir: /tests
  command: bash /scripts/run-tests.sh
  depends_on:
    - web
    - db
  networks:
    - wordpress_net
  environment:
    MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

### Running Automated Tests

1. **Start the environment**:
   ```bash
   docker-compose up -d
   ```

2. **Run tests**:
   ```bash
   docker-compose run --rm test-runner
   ```

3. **View test results**:
   - Logs sẽ hiển thị trong terminal
   - Test results có thể được lưu trong `./tests/results/`

### Test Scripts Structure

- **`scripts/run-tests.sh`**: Main test runner script
- **`tests/`**: Thư mục chứa test files
  - Unit tests
  - Integration tests
  - End-to-end tests

### Example Test Workflow

```bash
# Start services
docker-compose up -d

# Wait for services to be ready
sleep 30

# Run tests
docker-compose run --rm test-runner

# Stop services
docker-compose down
```

### Alternative Options (if needed)

## Option 1: Install Docker Desktop on Windows

1. Download Docker Desktop từ https://www.docker.com/products/docker-desktop
2. Install và enable WSL 2 backend nếu có

## Option 2: Setup Ubuntu VM using WSL2

1. Enable WSL2: `wsl --install -d Ubuntu`
2. Start Ubuntu: `wsl -d Ubuntu`
3. Install Docker: `sudo apt install docker.io`

### Customizing Tests

Thêm test scripts của bạn vào thư mục `tests/` và cập nhật `scripts/run-tests.sh` để chạy chúng.

Ví dụ:
- Test database schema
- Test WordPress API endpoints
- Test plugin functionality
- Performance tests