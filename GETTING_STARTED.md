# Getting Started with Swim Application Development

## Project Overview

You now have a complete foundation for a modern swim application with:
- **Backend**: Rails 8.1 API with all models, services, and business logic from the original app
- **Frontend**: React 18 + TypeScript + Vite with TailwindCSS
- **Infrastructure**: Docker Compose with PostgreSQL, Redis, and Sidekiq

## Project Structure

```
swim/
├── backend/              # Rails API
│   ├── app/
│   │   ├── controllers/
│   │   │   └── api/v1/  # API controllers
│   │   ├── models/      # All models from original app
│   │   ├── services/    # Business logic services
│   │   └── jobs/        # Background jobs
│   ├── db/
│   │   └── migrate/     # All migrations from original app
│   ├── Dockerfile
│   └── .env.example
│
├── frontend/             # React SPA
│   ├── src/
│   │   ├── components/  # React components (organized by feature)
│   │   ├── pages/       # Page components
│   │   ├── services/    # API service layer
│   │   ├── hooks/       # Custom React hooks
│   │   ├── types/       # TypeScript type definitions
│   │   └── App.tsx      # Main app with routing
│   ├── Dockerfile
│   ├── ARCHITECTURE.md  # Detailed component architecture
│   └── .env.example
│
├── docker-compose.yml   # All services orchestration
├── README.md           # Complete documentation
└── GETTING_STARTED.md  # This file
```

## Quick Start

### 1. Initial Setup

```bash
cd swim

# Backend environment
cd backend
cp .env.example .env
# Edit .env and add your ANTHROPIC_API_KEY

# Frontend environment
cd ../frontend
cp .env.example .env

cd ..
```

### 2. Start Docker Services

```bash
# Build and start all services
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build
```

This will start:
- PostgreSQL (port 5432)
- Redis (port 6379)
- Rails API (port 3000)
- Sidekiq (background jobs)
- React frontend (port 5173)

### 3. Access the Application

- Frontend: http://localhost:5173
- Backend API: http://localhost:3000/api/v1
- API Health Check: http://localhost:3000/up

## Development Workflow

### Backend Development

The backend has all the models, services, and business logic from your original application. The main work needed is:

1. **Complete API Controllers**: Some controllers have placeholder methods marked "to be implemented"
2. **Set up Devise JWT**: Configure devise-jwt for token-based authentication
3. **Test API Endpoints**: Ensure all endpoints return correct JSON responses

Key files to work on:
- `backend/app/controllers/api/v1/*_controller.rb`
- `backend/config/initializers/devise.rb` (needs to be created for JWT)
- `backend/config/routes.rb` (routes are defined but may need adjustments)

### Frontend Development

The frontend has a basic structure. Follow the architecture in `frontend/ARCHITECTURE.md`:

**Next Steps:**

1. **Authentication Flow**
   - Implement LoginForm and SignupForm components
   - Create AuthContext for managing user state
   - Set up protected routes

2. **Core Components** (in priority order)
   - Layout components (Header, MainLayout)
   - Dashboard page
   - Swimmers list and detail pages
   - Meetings list and detail pages
   - Comparison view

3. **Services Layer**
   - Create service files for API calls:
     - `services/auth.service.ts`
     - `services/swimmers.service.ts`
     - `services/performances.service.ts`
     - `services/meetings.service.ts`

4. **Custom Hooks**
   - Implement React Query hooks for data fetching
   - Create useAuth hook for authentication

### Useful Commands

**Docker:**
```bash
# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f sidekiq

# Run Rails commands
docker-compose exec backend rails console
docker-compose exec backend rails db:migrate
docker-compose exec backend rails routes

# Run bundle install after adding gems
docker-compose exec backend bundle install
docker-compose restart backend

# Install npm packages
docker-compose exec frontend npm install <package>
docker-compose restart frontend

# Stop all services
docker-compose down

# Stop and remove volumes (fresh start)
docker-compose down -v
```

**Backend (if running locally):**
```bash
cd backend

# Console
rails console

# Run migrations
rails db:migrate

# Run tests
bundle exec rspec

# Check routes
rails routes | grep api
```

**Frontend (if running locally):**
```bash
cd frontend

# Install packages
npm install

# Run dev server
npm run dev

# Build for production
npm run build

# Type checking
npm run type-check
```

## Authentication Setup

The backend needs Devise JWT configuration. Here's what needs to be done:

1. Create `config/initializers/devise.rb` with JWT settings
2. Add `devise_jwt` to the User model
3. Update sessions and registrations controllers for API
4. Test login/signup endpoints

Reference for Devise JWT: https://github.com/waiting-for-dev/devise-jwt

## API Endpoints Reference

All endpoints are under `/api/v1`:

**Authentication:**
- POST `/signup` - Register
- POST `/login` - Login
- DELETE `/logout` - Logout

**Swimmers:**
- GET `/swimmers` - List all
- GET `/swimmers/:id` - Show one
- POST `/swimmers` - Create
- PATCH `/swimmers/:id` - Update
- DELETE `/swimmers/:id` - Delete

**Performances:**
- POST `/performances/import` - Import from SE
- GET `/swimmers/:id/performances/:stroke/:distance/:course` - History

**Meetings:**
- GET `/meetings` - List all
- GET `/meetings/:id` - Show one
- POST `/meetings` - Upload PDF
- GET `/meetings/:id/status` - Check parsing status
- GET `/meetings/:id/review` - Review parsed data
- POST `/meetings/:id/confirm` - Confirm meeting
- DELETE `/meetings/:id` - Delete

**Dashboard:**
- GET `/dashboard` - Dashboard data

## Component Implementation Priority

Based on user flows, implement in this order:

1. **Authentication** (LoginForm, SignupForm, AuthContext)
2. **Layout** (Header, MainLayout)
3. **Dashboard** (DashboardPage, StatsCard)
4. **Swimmers** (SwimmerList, SwimmerForm, SwimmerDetail)
5. **Performances** (ImportForm, PerformanceTable)
6. **Meetings** (MeetingList, MeetingDetail, PDFUpload)
7. **Comparison** (ComparisonView, StandardsMatrix)

## Styling Guide

Using TailwindCSS with these conventions:

**Colors:**
- Primary: `blue-600`, `blue-700` (buttons, links)
- Success: `green-500`, `green-600` (qualified)
- Warning: `yellow-500`, `yellow-600` (consideration)
- Danger: `red-500`, `red-600` (not qualified)
- Neutral: `gray-50` to `gray-900`

**Common Patterns:**
```tsx
// Card
<div className="bg-white rounded-lg shadow-md p-6">

// Button
<button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">

// Input
<input className="border border-gray-300 rounded-lg px-4 py-2 w-full focus:ring-2 focus:ring-blue-500">

// Table
<table className="min-w-full divide-y divide-gray-200">
```

## Testing

**Backend:**
- RSpec is configured
- Write tests for API endpoints
- Test services and models

**Frontend:**
- Jest and React Testing Library are available
- Write component tests
- Test hooks and services

## Common Issues & Solutions

**Database connection errors:**
```bash
# Wait for PostgreSQL to be ready
docker-compose down
docker-compose up -d db
sleep 10
docker-compose up backend
```

**Port conflicts:**
```bash
# Check if ports are in use
lsof -i :3000  # Backend
lsof -i :5173  # Frontend
lsof -i :5432  # PostgreSQL

# Kill processes or change ports in docker-compose.yml
```

**Bundle/npm install issues:**
```bash
# Rebuild without cache
docker-compose build --no-cache backend
docker-compose build --no-cache frontend
```

## Next Steps

1. **Set up authentication**
   - Configure Devise JWT
   - Implement login/signup forms
   - Create AuthContext

2. **Build core features**
   - Follow the component priority list
   - Implement one feature at a time
   - Test as you go

3. **Polish UI**
   - Add loading states
   - Implement error handling
   - Add form validation

4. **Optimize**
   - Add React Query caching
   - Implement lazy loading
   - Optimize bundle size

## Resources

- **Rails API**: https://guides.rubyonrails.org/api_app.html
- **React Router**: https://reactrouter.com/
- **React Query**: https://tanstack.com/query/latest
- **TailwindCSS**: https://tailwindcss.com/docs
- **TypeScript**: https://www.typescriptlang.org/docs
- **Devise JWT**: https://github.com/waiting-for-dev/devise-jwt

## Need Help?

- Check `README.md` for overall architecture
- Check `frontend/ARCHITECTURE.md` for component structure
- Review original `swim-ruby` app for business logic reference
- All models, services, and jobs are preserved in the backend

Happy coding! 🏊‍♂️
