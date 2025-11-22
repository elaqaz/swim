# Swim Meet Manager – Product Documentation

> Working name: **Swim**  
> Primary audience: **Parents of competitive swimmers**  
> Secondary audiences: swimmers, coaches

---

## 1. Product Overview

Swim is a mobile-first web app that tells parents **instantly** whether their child qualifies for upcoming pathway meets (Yorkshire → Regionals → Nationals → British), without hunting PDFs or doing manual calculations.

The app pulls official race data from **SwimmingResults.org** and combines it with **meet qualification standards**, **age rules**, and **pool conversions**. During galas, parents can enter **temporary unofficial times** to see projected qualification; these are automatically replaced when official results appear.

Swim focuses on:

- **Clarity** – a simple “Qualified / Not yet / Unofficial” view per event.
- **Automation** – zero spreadsheets, minimal manual data entry.
- **Emotional reassurance** – removing uncertainty and stress around eligibility checks.

---

## 2. Product Vision

- Help swimmers and their families **know if and where they qualify** for pathway meets, with minimal manual work.
- Provide a **single, trusted view** of performances, standards, and eligibility.
- Turn complex rules into **clear, visual signals** that support decisions about entries and season planning.

---

## 3. Target Users & Personas

### 3.1 Primary User – Parent (“Maggie Evans”)

Busy parent managing 1–3 competitive swimmers in different age groups. Tech-comfortable (medium), uses a phone during galas and a laptop/tablet at home. Currently spends hours comparing PDFs, SwimmingResults pages, and spreadsheets.

**Goals**

- Immediately see whether each child qualifies for upcoming meets.
- Avoid mistakes caused by pool conversions, age-at-date rules, and meet levels.
- Plan meet entries and season strategy confidently.
- Track PBs and progress without building their own tooling.

**Frustrations**

- Qualification rules scattered across PDFs and websites.
- Need to check multiple sites (county, region, national).
- Manual calculations, error-prone comparisons (especially pool conversions).
- Stressful environment at meets (hot, noisy, only a phone).  [oai_citation:2‡swim.pdf](sediment://file_00000000639072468f97108d81551495)

### 3.2 Secondary Users

- **Swimmers (Sarah Lin)** – want to see visual progress and understand what’s needed to qualify.  [oai_citation:3‡swim.pdf](sediment://file_00000000639072468f97108d81551495)
- **Coaches (Mark Taylor)** – may later use team dashboards for squad-level eligibility and planning.  [oai_citation:4‡swim.pdf](sediment://file_00000000639072468f97108d81551495)

### 3.3 Internal Users

- **Meet/Data Admins** – manage PDF ingestion, correct parsing errors, maintain meet standards, and monitor data quality.

---

## 4. Problem Statement

Parents cannot easily tell whether their child qualifies for upcoming pathway meets because:

- Qualification standards are **hidden in PDFs** across multiple websites (county, region, nationals).  [oai_citation:5‡swim.pdf](sediment://file_00000000639072468f97108d81551495)
- Official race times are on **SwimmingResults.org**, but not joined to those standards.
- Rules vary by **age window, pool length, stroke, distance, and meet level**.
- Conversions (25m ↔ 50m) and column layouts make it easy to misread or pick the wrong time.
- During galas, official results are **not yet available**, but parents still want to know if a swim qualifies.

This leads to:

- Hours of manual checking (often in spreadsheets).
- High risk of errors (entering wrong age category, wrong pool, wrong column).
- Stress and uncertainty for families right at the moment that should feel exciting.

---

## 5. Core Value Proposition

> **“The moment your child finishes a race, Swim tells you whether they qualify for upcoming meets – using official or temporary times – without PDFs, spreadsheets, or guesswork.”**

Key differentiators:

1. **On-the-fly qualification checks** – always calculated live, never stale cached flags.
2. **Temporary unofficial times** during galas, clearly marked and auto-replaced by official data.
3. **Pathway-aware meet list** – only shows relevant meets (Yorkshire, region, national, GB) for the swimmer’s region and age.
4. **Mobile-first design** optimised for real gala conditions.
5. **Multi-child support** in one parent account.

---

## 6. Scope

### 6.1 In Scope (MVP)

- Parent accounts and multi-swimmer profiles.
- Automatic import of official performances from SwimmingResults.org.
- Manual entry of **temporary unofficial times** during galas.
- Meet standards ingestion from PDFs (county, regional, national, GB).
- On-the-fly qualification calculation for each swimmer and event.
- Pathway meet list filtered to swimmer’s region and age eligibility.
- Progress / PB views and simple charts.
- Admin tools for meet standards review and correction.
- Basic data quality monitoring and error reporting.

### 6.2 Out of Scope (for now)

- Payments or electronic entry submission.
- Training planning / workout logging.
- Rich team dashboards for coaches (beyond basic read-only).
- Non-UK regions or multi-sport support.

---

## 7. Key User Journeys

### 7.1 Add Swimmer & See Qualification

1. Parent creates an account.
2. Adds one or more swimmers with: **Name, Date of Birth, Sex, Swim England Membership ID**, optional club.
3. System pulls official times from SwimmingResults.org in the background.
4. Parent opens the swimmer profile:
    - sees PBs per event and course
    - sees qualification status for each **pathway meet** (Yorkshire, region, national, GB) in their region.

### 7.2 Check Qualification During a Gala

1. Parent opens the swimmer screen on mobile.
2. Enters **temporary time** for the just-swum event (stroke, distance, course, time).
3. System immediately calculates eligibility for all relevant pathway meets:
    - Shows **“Qualified – unofficial time”** where applicable.
    - Shows “Close, 0.45s off” or “Not yet” elsewhere.
4. Once official results appear on SwimmingResults.org:
    - System imports them.
    - Replaces temporary data silently.
    - Qualification status updates automatically.

### 7.3 Upload Meet Standards (Admin)

1. Admin uploads a meet qualification PDF (e.g. Yorkshire Winter Champs).
2. Claude parsing pipeline extracts:
    - Meet metadata (name, season, dates, region, pool, level).
    - Age rules (age-at-date vs end-of-year).
    - Standards grid by age, sex, stroke, distance.
3. Parsed standards appear in an admin **review queue**.
4. Admin reviews, corrects if needed, and publishes.
5. System immediately uses published standards for all eligibility checks.

### 7.4 Track Progress

1. Parent opens **Progress** tab for a swimmer.
2. Sees charts of times over time per event, PB highlights, and how far each event is from qualification.
3. Optional: “Closest to qualifying” list to focus on the best improvement opportunities.

### 7.5 Report Data Issue

1. Parent sees something wrong (missing time, wrong standard).
2. Uses in-app **“Report an issue”** form tied to a meet / event / time.
3. Issue appears in admin queue with context; admin can fix data or re-parse PDFs.

---

## 8. Functional Requirements

### 8.1 Accounts & Roles

- **Parent accounts**
    - Email/password authentication (Devise).
    - Can manage 1–3+ swimmers.
- **Admin accounts**
    - Can upload and review PDFs, correct standards, manage meets, and view error reports.
- Future: **Coach accounts** (read-only or team dashboards).

### 8.2 Swimmer Management

- A parent can:
    - Add/edit swimmers with: Name, DOB, Sex, Swim England ID, Club (optional).
    - Switch between swimmers from a top-level “Swimmers” section (as in IA).  [oai_citation:6‡swim.pdf](sediment://file_00000000639072468f97108d81551495)
- System:
    - Uses DOB, sex, and (eventually) region/club to determine eligible meets.
    - Treats SwimmingResults.org as the **source of truth** for official times.

### 8.3 Region & Pathway

- Region assignment is currently **TBD**, but the system must support:
    - Deriving region from **club** or **postcode**.
    - Mapping each region to a standard **pathway**:
        - County (Yorkshire)
        - Regional (North East Region)
        - Nationals
        - British Champs
- Parents should only see meets in their swimmer’s pathway (no unrelated counties).

### 8.4 Data Ingestion – Official Times

- Background job pulls performances from SwimmingResults.org for each swimmer:
    - At onboarding.
    - On a schedule (e.g. daily) and/or after known meets.
- Stored data per performance:
    - Swimmer, meet, date, stroke, distance, course type (SC/LC), time, level (e.g. L3).
- Times are never manually overwritten; any manual data is stored separately as **temporary**.

### 8.5 Temporary Unofficial Times

- Parent can enter a temporary time for an event during a gala:
    - Required: stroke, distance, course type, time, date.
- Qualification engine:
    - Includes temporary times when calculating eligibility.
    - Marks resulting statuses as **“Qualified (unofficial time)”**.
- Replacement rules:
    - When an official time is later imported for the same swimmer, event, meet/date:
        - Temporary record is automatically deleted or deactivated.
        - Only official time is used going forward.
- Temporary times are never treated as a permanent source of truth.

### 8.6 Meet Standards & Metadata

- Admin uploads standards as PDFs.
- Parsing pipeline (Claude) extracts:
    - Meet name, season, region, level, pool requirement, date range.
    - Age rule (age-at-date vs end-of-year vs other).
    - Standards matrix by age, sex, stroke, distance.
- Admin UI:
    - Review queue of parsed meets.
    - Side-by-side view of PDF vs extracted data.
    - Ability to correct values and re-parse if needed.
    - Versioning: keep history of standards and who changed what.
- Published standards are immediately active for all eligibility calculations.

### 8.7 Qualification Engine (On-the-Fly)

- **No persistent “qualified” flags** – all qualification status is computed live when:
    - a parent opens a swimmer or meet view
    - (or an API consumer requests it)
- Inputs:
    - Swimmer: DOB, sex, region/club.
    - Official and temporary times (with pool types and levels).
    - Meet standards + rules:
        - Age window (at event date or end-of-year).
        - Pool type requirement (LC only, SC allowed, conversions allowed).
        - Meet level constraints (e.g. times must be from L3 or better).
- Behaviour:
    - Determine swimmer’s **age category** for each meet.
    - Select applicable **official times**, apply conversions if rules allow.
    - Consider temporary times where present, marking them as unofficial.
    - Compare times against standard times and determine status per event:
        - `QUALIFIED_OFFICIAL`
        - `QUALIFIED_UNOFFICIAL`
        - `CLOSE` (within X seconds, configurable)
        - `NOT_QUALIFIED`
- Outputs:
    - For each meet and event, a status badge + gap in seconds.
    - “Closest to qualifying” list (sorted by smallest positive gap).

### 8.8 Meets & Pathway Screen

- “Meets” section lists pathway meets relevant to the swimmer’s region and age.
- For each meet:
    - Basic metadata (name, location, dates, pool).
    - Entry window (open/closed if available).
    - Quick summary: number of qualified events (official vs unofficial).
- Parents **cannot hide meets**; the pathway is intentionally complete.

### 8.9 Dashboard & Progress

Aligned with your IA: Dashboard → Swimmers → Meets → Settings.  [oai_citation:7‡swim.pdf](sediment://file_00000000639072468f97108d81551495)

- **Dashboard**
    - For multi-swimmer families: overview cards per swimmer.
    - Key stats: # of qualified events, next upcoming meet, PB summary.
- **Progress views**
    - Per event: line chart of times over time.
    - Badge when a PB also meets a qualification standard.
    - Visual highlight of events closest to qualification.

### 8.10 Admin & Data Quality

- Admin features:
    - PDF uploads and meet review pipeline.
    - Error report triage and resolution.
    - Audit log (who changed which standard, when).
- Error handling:
    - Parents can flag “this looks wrong” from any meet or performance.
    - Admin queue groups similar issues and shows underlying records.

---

## 9. Non-Functional Requirements

- **Performance**
    - Live qualification calculations must return within < 500 ms per swimmer + meet selection.
- **Availability**
    - Target 99.5% uptime for core user flows (view swimmer, view qualification).
- **Security**
    - JWT-secured API (Rails 8.1 + Devise) as already implemented.  [oai_citation:8‡PRODUCT_DOCUMENTATION.md](sediment://file_000000006ce87243b5105970d5deaedc)
    - Only minimal personal data stored (no addresses; DOB is required).
- **Privacy**
    - Parents only see their own swimmers.
    - Admins see swimmers only through anonymised views where possible.
- **Observability**
    - Metrics on parsing success rates, error rates, and import latency.
    - Logging for key processes (imports, parsing, qualification engine errors).

---

## 10. Data & Integrations

- **External Sources**
    - SwimmingResults.org – official times import.
    - Claude API – PDF parsing of meet standards.  [oai_citation:9‡PRODUCT_DOCUMENTATION.md](sediment://file_000000006ce87243b5105970d5deaedc)
- **Identifiers**
    - Swim England membership ID (per swimmer).
    - Meet license numbers and/or unique identifiers.
- **Storage**
    - PostgreSQL for core data.
    - Redis + Sidekiq for background jobs and queues.

---

## 11. Success Measures

- Median time from **signup → first qualification check** < 5 minutes.
- ≥ 98% of supported meet standards require **no manual corrections**.
- Data freshness:
    - New official results imported within 24 hours of posting.
- Qualitative:
    - Parents report “I no longer need spreadsheets/notes to track qualification.”
- Error rate:
    - < 2% of meets flagged by users for data issues per month.

---

## 12. Open Questions / TBD

1. **Region assignment mechanism**
    - Club-based, postcode-based, SE-based, or hybrid?
2. **Exact pathway rules**
    - For each region, which meets count as part of the standard pathway?
3. **Conversion rules**
    - Which meets accept SC→LC and LC→SC, and which do not?
4. **Coach features**
    - When and how to add coach dashboards beyond parent experience?
5. **Notifications**
    - Should parents receive alerts when a new time qualifies for a higher-level meet?

---

## 13. Future Extensions (Beyond MVP)

- Coach dashboards showing squad-level qualification.
- Seasonal planning tools (recommended meets per swimmer).
- Deeper progress analytics (e.g. improvement rate, event specialisation).
- Expansion to other regions/countries.
- Native mobile apps if usage/engagement justifies.

---

_This document is the living source of truth for Swim’s product direction. UX artefacts (personas, case study, IA, and wireframes) complement this spec by detailing interactions and visual design._
