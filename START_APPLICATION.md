# How to Start the Swim Application

## Prerequisites

Before starting the application, ensure you have:

1. **Docker Desktop** installed and running
   - Download from: https://www.docker.com/products/docker-desktop
   - Make sure Docker Desktop is started (you should see the whale icon in your menu bar)

2. **Environment files configured**

## Step-by-Step Startup

### 1. Start Docker Desktop

On macOS, you can start Docker Desktop by:
- Opening Docker Desktop from Applications
- Or using Spotlight (Cmd + Space, type "Docker")
- Wait until the whale icon appears in the menu bar and shows "Docker Desktop is running"

### 2. Configure Environment Variables

```bash
# Navigate to the project
cd /Users/bartoszszymichowski/42sid/swim

# Set up backend environment
cd backend
cp .env.example .env

# Edit .env and add your credentials:
# - ANTHROPIC_API_KEY (for PDF parsing with Claude)
# - SECRET_KEY_BASE (generate with: rails secret, or leave as is for dev)

# Set up frontend environment
cd ../frontend
cp .env.example .env
# (The defaults are fine for local development)

cd ..
```

### 3. Start All Services

```bash
# From the swim directory
docker compose up -d --build
```

This will start:
- PostgreSQL database (port 5432)
- Redis (port 6379)
- Rails API backend (port 3000)
- Sidekiq worker (for background jobs)
- React frontend (port 5173)

### 4. Wait for Services to be Ready

The first time you run this, it will:
- Build Docker images (2-5 minutes)
- Install all dependencies
- Create and migrate the database

```bash
# Watch the logs to see when everything is ready
docker compose logs -f backend frontend

# You should see messages like:
# backend    | * Listening on http://0.0.0.0:3000
# frontend   | ➜  Local:   http://localhost:5173/
```

Press Ctrl+C to stop watching logs (services continue running in background)

### 5. Access the Application

Open your browser and navigate to:

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000/api/v1
- **Health Check**: http://localhost:3000/up

### 6. Create Your First User

1. Go to http://localhost:5173
2. Click "Sign Up"
3. Enter your email and password
4. You'll be redirected to the dashboard

## Common Commands

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f sidekiq
```

### Stop Services
```bash
docker compose down
```

### Restart Services
```bash
docker compose restart
```

### Rebuild After Code Changes
```bash
# Rebuild specific service
docker compose up -d --build backend

# Rebuild all
docker compose up -d --build
```

### Run Rails Commands
```bash
# Rails console
docker compose exec backend rails console

# Run migrations
docker compose exec backend rails db:migrate

# Create database (first time only)
docker compose exec backend rails db:create db:migrate

# Run seeds
docker compose exec backend rails db:seed
```

### Run Frontend Commands
```bash
# Install new npm package
docker compose exec frontend npm install <package-name>

# Run frontend shell
docker compose exec frontend sh
```

### Database Commands
```bash
# Access PostgreSQL
docker compose exec db psql -U postgres -d swim_development

# Reset database
docker compose exec backend rails db:reset
```

## Troubleshooting

### Issue: "Cannot connect to Docker daemon"
**Solution**: Start Docker Desktop and wait for it to be fully running

### Issue: Port already in use
**Solution**:
```bash
# Find what's using the port
lsof -i :3000  # or :5173, :5432, etc.

# Stop the process or change the port in docker-compose.yml
```

### Issue: Database connection errors
**Solution**:
```bash
# Wait for database to be ready
docker compose up -d db
sleep 10

# Then start other services
docker compose up -d
```

### Issue: "Bundle not found" or gem errors
**Solution**:
```bash
# Rebuild the backend container
docker compose build --no-cache backend
docker compose up -d backend
```

### Issue: Frontend build errors
**Solution**:
```bash
# Rebuild frontend
docker compose build --no-cache frontend
docker compose up -d frontend
```

### Issue: Changes not reflecting
**Solution**:
```bash
# For backend changes, restart
docker compose restart backend

# For frontend, it should auto-reload
# If not, rebuild:
docker compose restart frontend
```

## Development Workflow

### Backend Development (Rails)

1. Make changes to Ruby files
2. Restart backend: `docker compose restart backend`
3. View logs: `docker compose logs -f backend`

### Frontend Development (React)

1. Make changes to TypeScript/React files
2. Vite will auto-reload (watch the browser)
3. If issues: `docker compose restart frontend`

### Database Changes

1. Create migration: `docker compose exec backend rails generate migration AddFieldToModel`
2. Edit migration in `backend/db/migrate/`
3. Run migration: `docker compose exec backend rails db:migrate`

## Stopping the Application

### Stop All Services
```bash
docker compose down
```

### Stop and Remove All Data (Fresh Start)
```bash
docker compose down -v
```
⚠️ This will delete your database!

## Performance Tips

### Speed Up Builds
The application uses Docker volumes to cache:
- Ruby gems (bundle_cache)
- Node modules
- Database data (postgres_data, redis_data)

These persist between runs, so subsequent starts are much faster.

### Logs Taking Too Much Space
```bash
# Clean up old logs
docker compose down
docker system prune -a
```

## Next Steps

Once the application is running:

1. **Create a swimmer**: Dashboard → "Add Swimmer"
2. **Import times**: From swimmer detail page, click "Import from SE"
3. **Upload a meeting**: Dashboard → "Upload Meeting" → Select PDF
4. **Compare swimmers**: Go to a meeting → "Compare Swimmers"

## Need Help?

Check the documentation:
- `README.md` - Overall architecture
- `GETTING_STARTED.md` - Development guide
- `IMPLEMENTATION_COMPLETE.md` - What's implemented
- `TEST_RESULTS.md` - Test results

---

## Quick Reference

```bash
# Start everything
docker compose up -d --build

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop everything
docker compose down

# Access backend console
docker compose exec backend rails console

# Access database
docker compose exec db psql -U postgres -d swim_development
```

🏊‍♂️ Happy swimming! 🎉
