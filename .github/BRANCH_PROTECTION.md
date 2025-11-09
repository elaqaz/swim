# Branch Protection Setup

To enable CI checks before merging to main, configure these branch protection rules in GitHub:

1. Go to **Settings** → **Branches** → **Add branch protection rule**

2. Configure the following settings:

   **Branch name pattern:** `main`

   ✅ **Require a pull request before merging**
   - Require approvals: 1 (optional, for team projects)
   - Dismiss stale pull request approvals when new commits are pushed

   ✅ **Require status checks to pass before merging**
   - Require branches to be up to date before merging
   - Status checks that are required:
     - `Backend Tests`
     - `Backend Lint (RuboCop)`
     - `Frontend Lint (ESLint)`
     - `Frontend TypeScript Check`
     - `Frontend Build`

   ✅ **Require conversation resolution before merging**

   ✅ **Do not allow bypassing the above settings**

3. Click **Create** to save the protection rule

## CI Workflow

The GitHub Actions workflow (`.github/workflows/ci.yml`) will automatically run on:
- Every push to `main` branch
- Every pull request targeting `main` branch

### Jobs

- **Backend Tests**: Runs Rails tests with PostgreSQL and Redis
- **Backend Lint**: Checks Ruby code style with RuboCop
- **Frontend Lint**: Checks TypeScript/React code with ESLint
- **Frontend TypeScript Check**: Validates TypeScript types
- **Frontend Build**: Ensures the app builds successfully

All jobs must pass before a PR can be merged to main.
