# Swim Application

A modern swimming performance tracking application with React frontend and Rails API backend.

## Architecture

```
swim/
├── frontend/          # React + TypeScript + Vite
├── backend/           # Rails 8.1 API
├── docker-compose.yml # Docker orchestration
└── README.md         # This file
```

### Technology Stack

**Frontend:**
- React 18 with TypeScript
- Vite for build tooling
- TailwindCSS for styling
- React Router for navigation
- Axios for API calls
- React Query for data fetching and caching
- Date-fns for date manipulation

**Backend:**
- Rails 8.1 (API mode)
- PostgreSQL 16
- Redis for caching and Sidekiq
- Devise + JWT for authentication
- Sidekiq for background jobs
- Anthropic Claude API for PDF parsing

## Getting Started

### Prerequisites

- Docker and Docker Compose
- (Optional) Node.js 20+ and Ruby 3.3+ for local development

### Quick Start with Docker

1. **Clone and navigate to the project:**
   ```bash
   cd swim
   ```

2. **Set up environment variables:**

   Backend:
   ```bash
   cd backend
   cp .env.example .env
   # Edit .env and add your ANTHROPIC_API_KEY
   ```

   Frontend:
   ```bash
   cd ../frontend
   cp .env.example .env
   ```

3. **Start all services:**
   ```bash
   cd ..
   docker-compose up --build
   ```

4. **Access the application:**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3000/api/v1
   - Database: localhost:5432

### Initial Setup

After starting the containers for the first time:

```bash
# Create and migrate database (happens automatically in docker-compose)
# But if needed manually:
docker-compose exec backend rails db:create db:migrate

# (Optional) Seed database
docker-compose exec backend rails db:seed
```

## Development

### Local Development (without Docker)

**Backend:**
```bash
cd backend

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Start Rails server
rails server -p 3000

# In another terminal, start Sidekiq
bundle exec sidekiq
```

**Frontend:**
```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev
```

### Running Tests

**Backend:**
```bash
docker-compose exec backend bundle exec rspec
```

**Frontend:**
```bash
docker-compose exec frontend npm test
```

## Application Features

### Core Features

1. **Swimmer Management**
   - Add/edit/delete swimmers
   - Track multiple swimmers per user
   - Import performance data from Swimming England

2. **Performance Tracking**
   - Import times from swimmingresults.org
   - Automatic LC/SC conversion
   - Performance history visualization
   - Personal bests tracking

3. **Meeting Standards**
   - Upload PDF documents (AI-powered parsing)
   - Manage qualifying times
   - Age group calculations
   - Multiple pool types (LC/SC)

4. **Comparison & Qualification**
   - Compare swimmers against meet standards
   - Visual qualification indicators
   - Time conversion based on meet rules
   - Public qualification checker

## API Documentation

### Authentication Endpoints

```
POST   /api/v1/signup          # Register new user
POST   /api/v1/login           # Login
DELETE /api/v1/logout          # Logout
```

### Resource Endpoints

```
GET    /api/v1/dashboard                                    # Dashboard data
GET    /api/v1/swimmers                                     # List swimmers
GET    /api/v1/swimmers/:id                                 # Swimmer details
POST   /api/v1/swimmers                                     # Create swimmer
PATCH  /api/v1/swimmers/:id                                 # Update swimmer
DELETE /api/v1/swimmers/:id                                 # Delete swimmer

GET    /api/v1/swimmers/:id/performances/:stroke/:distance/:course  # Performance history
POST   /api/v1/performances/import                          # Import performances

GET    /api/v1/meetings                                     # List meetings
GET    /api/v1/meetings/:id                                 # Meeting details
POST   /api/v1/meetings                                     # Upload PDF
GET    /api/v1/meetings/:id/status                          # PDF parsing status
GET    /api/v1/meetings/:id/review                          # Review parsed data
POST   /api/v1/meetings/:id/confirm                         # Confirm meeting
GET    /api/v1/meetings/:id/compare                         # Compare swimmers
DELETE /api/v1/meetings/:id                                 # Delete meeting

POST   /api/v1/check_qualification                          # Public qualification check
```

## Frontend Component Architecture

### Proposed Component Structure

```
src/
├── components/
│   ├── common/              # Reusable UI components
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Modal.tsx
│   │   ├── Table.tsx
│   │   ├── Form/
│   │   │   ├── Input.tsx
│   │   │   ├── Select.tsx
│   │   │   └── DatePicker.tsx
│   │   └── Loading.tsx
│   │
│   ├── layout/              # Layout components
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   ├── Footer.tsx
│   │   └── MainLayout.tsx
│   │
│   ├── swimmers/            # Swimmer-related components
│   │   ├── SwimmerList.tsx
│   │   ├── SwimmerCard.tsx
│   │   ├── SwimmerForm.tsx
│   │   ├── SwimmerDetails.tsx
│   │   └── PersonalBests.tsx
│   │
│   ├── performances/        # Performance components
│   │   ├── PerformanceTable.tsx
│   │   ├── PerformanceHistory.tsx
│   │   ├── ImportForm.tsx
│   │   └── TimeConverter.tsx
│   │
│   ├── meetings/            # Meeting components
│   │   ├── MeetingList.tsx
│   │   ├── MeetingCard.tsx
│   │   ├── MeetingDetails.tsx
│   │   ├── StandardsMatrix.tsx
│   │   ├── PDFUpload.tsx
│   │   ├── ReviewParsedData.tsx
│   │   └── ComparisonView.tsx
│   │
│   ├── dashboard/           # Dashboard components
│   │   ├── StatsCard.tsx
│   │   ├── RecentPerformances.tsx
│   │   └── QuickActions.tsx
│   │
│   └── auth/               # Authentication components
│       ├── LoginForm.tsx
│       ├── SignupForm.tsx
│       └── ProtectedRoute.tsx
│
├── pages/                  # Page components
│   ├── HomePage.tsx
│   ├── LoginPage.tsx
│   ├── SignupPage.tsx
│   ├── DashboardPage.tsx
│   ├── SwimmersPage.tsx
│   ├── SwimmerDetailPage.tsx
│   ├── MeetingsPage.tsx
│   ├── MeetingDetailPage.tsx
│   └── ComparisonPage.tsx
│
├── services/               # API service layer
│   ├── api.ts             # Axios instance with interceptors
│   ├── auth.service.ts
│   ├── swimmers.service.ts
│   ├── performances.service.ts
│   └── meetings.service.ts
│
├── hooks/                  # Custom React hooks
│   ├── useAuth.ts
│   ├── useSwimmers.ts
│   ├── usePerformances.ts
│   └── useMeetings.ts
│
├── contexts/              # React contexts
│   └── AuthContext.tsx
│
├── types/                 # TypeScript types
│   ├── swimmer.types.ts
│   ├── performance.types.ts
│   ├── meeting.types.ts
│   └── api.types.ts
│
├── utils/                 # Utility functions
│   ├── time.utils.ts     # Time formatting/parsing
│   ├── date.utils.ts     # Date calculations
│   └── validation.ts     # Form validation
│
├── App.tsx               # Main app component
└── main.tsx             # App entry point
```

## Database Schema

Key models from the original application have been copied:

- **User** - Authentication and user management
- **Swimmer** - Swimmer profiles
- **Performance** - Swimming times/results
- **Meeting** - Competition meets
- **MeetingStandard** - Qualifying times
- **MeetRule** - Time conversion rules
- **ParsedMeetDatum** - PDF parsing results

## Background Jobs

- **ImportPerformancesJob** - Scrapes times from swimmingresults.org
- **ParseMeetPdfJob** - Parses PDF with Claude AI
- **ProcessMeetResponseJob** - Processes AI response

## Services

All business logic services from the original app:
- **SwimmingResultsScraper** - Web scraping
- **TimeConverter** - LC/SC conversions
- **EligibilityService** - Qualification checking
- **PublicQualificationChecker** - Public checker

## Environment Variables

### Backend (.env)

```bash
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
REDIS_URL=redis://redis:6379/0
FRONTEND_URL=http://localhost:5173
ANTHROPIC_API_KEY=your_api_key
SECRET_KEY_BASE=generated_secret
```

### Frontend (.env)

```bash
VITE_API_URL=http://localhost:3000/api/v1
```

## Docker Services

- **db** - PostgreSQL 16 database
- **redis** - Redis for caching and Sidekiq
- **backend** - Rails API server (port 3000)
- **sidekiq** - Background job processor
- **frontend** - React dev server (port 5173)

## Deployment

(To be added based on your deployment strategy)

## Contributing

(To be added)

## License

(To be added)

## Notes

This application is a complete rewrite of the swim-ruby monolith application, separating concerns into:
- A stateless Rails API backend
- A modern React SPA frontend
- Containerized services for easy deployment

The backend preserves all business logic, models, and services from the original application while exposing them through a RESTful JSON API.
