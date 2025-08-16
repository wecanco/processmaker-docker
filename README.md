# ProcessMaker Docker Deployment

## Features
- Supports both MySQL 8.0 and PostgreSQL 15
- Redis 7 for caching and queues
- PHP 8.2 with optimized extensions
- Nginx 1.25 as web server
- Health checks for all services
- Proper volume management

## Prerequisites
- Docker 20.10+ 
  ```bash
  apt install -y docker.io
  ```
- Docker Compose 1.29+ 
  ```bash
  curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ```
- Git
  ```bash
  apt install -y git curl wget nano
  ```
## Quick Start

### For MySQL version:
```bash
cp .env.example .env
# Edit .env file as needed
docker-compose -f docker-compose-mysql.yml up -d --build
```

### For PostgreSQL version:
```bash
cp .env.example .env
# Edit .env and set DB_CONNECTION=pgsql
docker-compose -f docker-compose-pgsql.yml up -d --build
```

## Accessing the Application
- ProcessMaker: http://localhost:8000
- Default admin credentials:
    - Username: admin@processmaker.com
    - Password: admin

## Maintenance Commands
```bash
# Run artisan commands
docker-compose exec app php artisan [command]

# View logs
docker-compose logs -f [service]

# Backup database
# For MySQL:
docker exec pm_mysql mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_DATABASE > backup.sql

# For PostgreSQL:
docker exec pm_postgres pg_dump -U $DB_USERNAME -d $DB_DATABASE > backup.sql
```

## Configuration
- PHP: `config/php/php.ini`
- Nginx: `config/nginx/processmaker.conf`
- MySQL: `config/mysql/my.cnf`
- PostgreSQL: `config/postgres/postgresql.conf`

## Notes
1. First run will take several minutes to build and initialize
2. For production use:
    - Set proper APP_KEY
    - Configure real mail server
    - Enable HTTPS in Nginx
