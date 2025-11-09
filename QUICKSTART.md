# 🚀 Quick Start Guide

## Prerequisites

✅ **Docker Desktop must be running**
- If not installed: Download from https://www.docker.com/products/docker-desktop
- Start Docker Desktop and wait for the whale icon in your menu bar

## 3-Step Start

### 1️⃣ Configure Environment (One-time setup)

```bash
cd /Users/bartoszszymichowski/42sid/swim

# Backend
cd backend
cp .env.example .env
# Optional: Edit .env to add your ANTHROPIC_API_KEY (only needed for PDF parsing)

# Frontend
cd ../frontend
cp .env.example .env

cd ..
```

### 2️⃣ Start Everything

```bash
docker compose up -d --build
```

⏱️ First time: 3-5 minutes (builds images, installs dependencies)
⏱️ Subsequent runs: ~30 seconds

### 3️⃣ Open Your Browser

**Frontend**: http://localhost:5173

Click "Sign Up" to create your account!

---

## What's Running?

| Service | Port | URL |
|---------|------|-----|
| React Frontend | 5173 | http://localhost:5173 |
| Rails API | 3000 | http://localhost:3000/api/v1 |
| PostgreSQL | 5432 | - |
| Redis | 6379 | - |
| Sidekiq | - | - |

## Common Commands

```bash
# View logs
docker compose logs -f

# Stop everything
docker compose down

# Restart after code changes
docker compose restart backend
docker compose restart frontend

# Rails console
docker compose exec backend rails console

# Database access
docker compose exec db psql -U postgres -d swim_development
```

## Troubleshooting

**"Cannot connect to Docker daemon"**
→ Start Docker Desktop

**Port already in use**
→ Stop other services on ports 3000, 5173, 5432, 6379

**Database errors**
→ `docker compose down -v && docker compose up -d --build`

**Not seeing changes**
→ `docker compose restart backend` or `docker compose restart frontend`

---

## What's Working?

✅ Full authentication (signup, login, logout)
✅ Dashboard with stats
✅ All 29 API endpoints
✅ Background jobs (Sidekiq)
✅ Complete business logic from original app

## Learn More

- `START_APPLICATION.md` - Detailed startup guide
- `README.md` - Full documentation
- `FINAL_SUMMARY.md` - Complete feature list

🏊‍♂️ **You're ready to swim!** 🎉
