# Frontend Architecture

## Component Organization

This document outlines the component structure for the Swim application frontend, based on analysis of the original Rails application.

## Design Principles

1. **Component Separation**: Components are organized by feature domain
2. **Reusability**: Common UI elements are extracted into shared components
3. **Type Safety**: Full TypeScript coverage for all components and services
4. **State Management**: React Query for server state, Context API for auth
5. **Styling**: TailwindCSS utility-first approach

## Page Structure

### Public Pages

1. **HomePage** (`/`)
   - Landing page with features overview
   - Public qualification checker form
   - Sign up / Login call to actions

### Authenticated Pages

2. **DashboardPage** (`/dashboard`)
   - Statistics cards (total swimmers, performances, meets)
   - Swimmers list overview
   - Meetings grid
   - Recent performances table

3. **SwimmersPage** (`/swimmers`)
   - Table view of all user's swimmers
   - Add new swimmer button
   - Search/filter functionality

4. **SwimmerDetailPage** (`/swimmers/:id`)
   - Swimmer information
   - LC Personal Bests table
   - SC Personal Bests table
   - Import performances button
   - Edit/Delete actions

5. **MeetingsPage** (`/meetings`)
   - Grid view of all meetings
   - Upload PDF button
   - Filter by season/region

6. **MeetingDetailPage** (`/meetings/:id`)
   - Meeting information
   - Standards matrix by gender
   - Age group columns
   - Event rows (stroke/distance)
   - Compare button

7. **ComparisonPage** (`/meetings/:id/compare`)
   - Multi-swimmer selection
   - Comparison table
   - Qualification status indicators
   - Time history modal

8. **PerformanceHistoryPage** (`/swimmers/:id/performances/:stroke/:distance/:course`)
   - All performances for specific event
   - Date sorted table
   - Personal best indicator
   - Meet names and venues

9. **ImportPerformancesPage** (`/performances/import`)
   - Swimmer selection
   - Historic mode toggle
   - Import button

## Component Breakdown

### Layout Components

**MainLayout**
- Contains Header, optional Sidebar, main content area, Footer
- Handles responsive layout
- Used as wrapper for authenticated routes

**Header**
- Navigation menu
- User profile dropdown
- Logout button
- Mobile menu toggle

**Sidebar** (optional)
- Quick navigation links
- Stats summary
- May be omitted for simpler layout

**Footer**
- Copyright
- Links

### Common Components

**Button**
- Variants: primary, secondary, danger, ghost
- Sizes: sm, md, lg
- Loading state
- Disabled state

**Card**
- Container for grouped content
- Optional header/footer
- Hover effects

**Modal**
- Overlay backdrop
- Close button
- Customizable content
- Animation on open/close

**Table**
- Sortable columns
- Pagination
- Row selection
- Responsive (scroll on mobile)

**Form Components:**
- Input (text, number, email)
- Select (dropdown)
- DatePicker
- Checkbox/Radio
- Form validation display

**Loading**
- Spinner
- Skeleton screens
- Progress bar

**Badge**
- Status indicators (qualified, consideration, not qualified)
- Color variants

### Swimmer Components

**SwimmerList**
- Displays table of swimmers
- Uses Table component
- Edit/Delete actions
- Click to view details

**SwimmerCard**
- Card display for dashboard
- Swimmer photo (optional)
- Name, age, club
- Quick stats

**SwimmerForm**
- Create/Edit swimmer
- Fields: first_name, last_name, dob, sex, club, se_membership_id
- Validation

**SwimmerDetails**
- Full swimmer information
- Performance summary
- Action buttons

**PersonalBests**
- Tables for LC and SC
- Grouped by stroke
- Distance columns
- Time display with formatting

### Performance Components

**PerformanceTable**
- Display performances
- Columns: date, meet, time, venue, license level
- Sortable
- Converted time indicators

**PerformanceHistory**
- Chart visualization (optional)
- Table of all performances for event
- Personal best highlighting

**ImportForm**
- Swimmer dropdown
- Historic mode checkbox
- Progress indicator
- Error handling

**TimeConverter**
- Display original and converted times
- Asterisk for conversions
- Tooltip with conversion info

### Meeting Components

**MeetingList**
- Grid or list of meetings
- Meeting cards
- Filter controls
- Sort options

**MeetingCard**
- Meeting name
- Season, region
- Pool type
- Age calculation method
- Quick actions

**MeetingDetails**
- Meeting information display
- Standards matrix
- Download PDF button

**StandardsMatrix**
- Complex table component
- Gender tabs
- Age group columns
- Event rows (stroke/distance)
- Time cells with qualification types
- Color coding

**PDFUpload**
- File input
- Drag-and-drop zone
- Upload progress
- Validation (PDF only)

**ReviewParsedData**
- Display parsed JSON
- Editable fields
- Confirm/Retry buttons
- Error display

**ComparisonView**
- Multi-swimmer selection
- Comparison table
- Qualification indicators:
  - Green: Qualified
  - Yellow: Consideration
  - Red: Not qualified
- Time delta display
- Click time to see history modal

**TimeHistoryModal**
- Modal overlay
- Performance timeline for specific event
- Used in comparison view

### Dashboard Components

**StatsCard**
- Icon
- Number (large)
- Label
- Trend indicator (optional)

**RecentPerformances**
- Table of recent swims
- Limited to 10 rows
- Link to full history

**QuickActions**
- Button grid
- Common tasks:
  - Add swimmer
  - Import times
  - Upload meeting
  - Check qualification

### Auth Components

**LoginForm**
- Email input
- Password input
- Remember me checkbox
- Submit button
- Link to signup

**SignupForm**
- Email, password, password confirmation
- Terms acceptance
- Submit button
- Link to login

**ProtectedRoute**
- HOC or component for route protection
- Redirects to login if not authenticated
- Shows loading while checking auth

## State Management

### Server State (React Query)

**Queries:**
- `useSwimmers` - Fetch all swimmers
- `useSwimmer(id)` - Fetch single swimmer
- `useMeetings` - Fetch all meetings
- `useMeeting(id)` - Fetch single meeting
- `useDashboard` - Fetch dashboard data
- `usePerformanceHistory` - Fetch performance history

**Mutations:**
- `useCreateSwimmer`
- `useUpdateSwimmer`
- `useDeleteSwimmer`
- `useImportPerformances`
- `useUploadMeeting`
- `useConfirmMeeting`

### Client State

**AuthContext:**
- Current user
- Token management
- Login/logout functions
- isAuthenticated flag

## Routing Structure

```tsx
<Routes>
  <Route path="/" element={<HomePage />} />
  <Route path="/login" element={<LoginPage />} />
  <Route path="/signup" element={<SignupPage />} />

  <Route element={<ProtectedRoute />}>
    <Route element={<MainLayout />}>
      <Route path="/dashboard" element={<DashboardPage />} />

      <Route path="/swimmers">
        <Route index element={<SwimmersPage />} />
        <Route path=":id" element={<SwimmerDetailPage />} />
        <Route path=":swimmerId/performances/:stroke/:distance/:course"
               element={<PerformanceHistoryPage />} />
      </Route>

      <Route path="/performances">
        <Route path="import" element={<ImportPerformancesPage />} />
      </Route>

      <Route path="/meetings">
        <Route index element={<MeetingsPage />} />
        <Route path="new" element={<UploadMeetingPage />} />
        <Route path=":id" element={<MeetingDetailPage />} />
        <Route path=":id/compare" element={<ComparisonPage />} />
      </Route>
    </Route>
  </Route>
</Routes>
```

## Data Flow

1. **User Interaction** → Component
2. **Component** → Hook (useSwimmers, etc.)
3. **Hook** → Service (swimmers.service.ts)
4. **Service** → API call (axios)
5. **API Response** → React Query cache
6. **Cache** → Hook → Component → UI Update

## Styling Approach

- **TailwindCSS** for all styling
- Custom theme configuration for brand colors
- Responsive design mobile-first
- Dark mode support (future enhancement)

### Color Scheme

Based on original app:
- **Primary**: Blue (#646cff equivalent)
- **Success** (Qualified): Green
- **Warning** (Consideration): Yellow/Orange
- **Danger** (Not Qualified): Red
- **Neutral**: Gray shades

## Type Definitions

### Core Types

```typescript
// swimmer.types.ts
interface Swimmer {
  id: number;
  first_name: string;
  last_name: string;
  dob: string;
  sex: 'M' | 'F';
  club: string;
  se_membership_id?: string;
  full_name: string;
  performances?: Performance[];
}

// performance.types.ts
interface Performance {
  id: number;
  swimmer_id: number;
  stroke: 'FREE' | 'BACK' | 'BREAST' | 'FLY' | 'IM';
  distance_m: 50 | 100 | 200 | 400 | 800 | 1500;
  course_type: 'LC' | 'SC';
  time_seconds: number;
  date: string;
  meet_name: string;
  venue?: string;
  license_level?: string;
  wa_points?: number;
  lc_time_seconds?: number;
  sc_time_seconds?: number;
}

// meeting.types.ts
interface Meeting {
  id: number;
  name: string;
  season: string;
  region?: string;
  promoter?: string;
  pool_required: 'LC' | 'SC';
  age_rule_type: string;
  age_rule_date?: string;
  window_start: string;
  window_end: string;
  meeting_standards?: MeetingStandard[];
}

interface MeetingStandard {
  id: number;
  meeting_id: number;
  stroke: string;
  distance_m: number;
  pool_of_standard: 'LC' | 'SC';
  standard_type: 'QUALIFY' | 'CONSIDER';
  time_seconds: number;
  age_min: number;
  age_max: number;
  gender: 'M' | 'F';
}
```

## Testing Strategy

- **Unit Tests**: Jest + React Testing Library
- **Integration Tests**: Component interaction tests
- **E2E Tests**: Playwright (future)
- **Coverage Target**: 80%+

## Performance Optimizations

1. **Code Splitting**: Lazy load routes
2. **Memoization**: React.memo for expensive components
3. **Virtualization**: For long tables/lists
4. **Image Optimization**: Lazy loading, responsive images
5. **Bundle Size**: Tree shaking, analyze bundle

## Accessibility

- Semantic HTML
- ARIA labels
- Keyboard navigation
- Screen reader support
- Color contrast compliance (WCAG AA)

## Future Enhancements

1. **Real-time Updates**: WebSocket for live parsing status
2. **Charts**: Performance progression charts
3. **Mobile App**: React Native version
4. **Offline Support**: PWA with service workers
5. **Dark Mode**: Theme toggle
6. **Multi-language**: i18n support
