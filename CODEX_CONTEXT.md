# E-Sumbong Flutter Migration — Master Context

You are assisting in migrating a Next.js PWA called E-Sumbong into a native Flutter app. This is a mission-critical incident reporting system for Philippine barangays, starting with Barangay Palatiw, Pasig City.

## Project Purpose
Residents submit incident reports (fire, crime, accident, medical, etc.) with GPS coordinates and photos. Barangay officials see these reports on a real-time map dashboard and respond. The app must work reliably offline and deliver push notifications.

## Current State
- The backend (Supabase) is fully built and functional.
- The original PWA frontend (Next.js) exists but is being replaced by Flutter.
- Backend schema, enums, and RLS policies are final — DO NOT modify them.

## Tech Stack (Fixed — Do Not Deviate)
- **Framework:** Flutter 3.x (Dart 3.x)
- **Backend:** Supabase (PostgreSQL + Storage + Realtime + Auth + Edge Functions)
- **Maps:** `flutter_map` + `latlong2` + OpenStreetMap tiles
- **Local DB (offline):** `drift` + `sqlite3_flutter_libs`
- **State management:** `riverpod` (flutter_riverpod)
- **Routing:** `go_router`
- **Auth:** `supabase_flutter`
- **Camera/Images:** `image_picker`
- **Location:** `geolocator`
- **Connectivity:** `connectivity_plus`
- **Notifications:** `firebase_messaging` + `flutter_local_notifications`
- **Icons:** `lucide_icons` (matches the PWA's lucide-react)
- **Date formatting:** `intl`

## Supabase Project
- URL and anon key are in `.env` (never commit). Use `flutter_dotenv` or `--dart-define`.
- **NEVER embed the service-role key in the app.** Server-side operations use Edge Functions.

## Database Schema (Public Schema — Read-Only Reference)

### barangays
id (uuid, PK), name (text), municipality (text), province (text), created_at (timestamptz)

### users
id (uuid, PK, FK -> auth.users), barangay_id (uuid, FK), role (user_role enum), full_name (text), phone (text, nullable), purok (text, nullable), is_verified (bool), verification_status (verification_status enum), created_at, updated_at

### resident_verifications
id (uuid, PK), user_id (uuid, FK), barangay_id (uuid, FK), id_number (text), address (text), document_path (text), status (verification_status enum), review_note (text, nullable), reviewed_by (uuid, nullable), reviewed_at (timestamptz, nullable), created_at

### incidents
id (uuid, PK), reference (text, DB-generated, e.g., "ES-2026-0004"), barangay_id (uuid, FK), reporter_id (uuid, nullable, FK), submitted_by (uuid, NOT NULL, FK), is_anonymous (bool), category (text), title (text), description (text), status (incident_status enum), priority (incident_priority enum), purok (text), address (text), latitude (numeric, nullable), longitude (numeric, nullable), assigned_to (uuid, nullable), resolved_at (timestamptz, nullable), created_at, updated_at

### incident_logs
id (uuid, PK), incident_id (uuid, FK), actor_id (uuid, nullable), action (text), from_status (incident_status, nullable), to_status (incident_status, nullable), note (text, nullable), is_public (bool), created_at

### attachments
id (uuid, PK), incident_id (uuid, FK), uploaded_by (uuid, FK), storage_path (text), file_name (text), media_type (text), size_bytes (bigint), created_at

### notifications
id (uuid, PK), user_id (uuid, FK), incident_id (uuid, nullable, FK), type (notification_type enum), title (text), body (text), read_at (timestamptz, nullable), created_at

## Enums (Exact Values)

```
user_role: resident | tanod | official | admin
verification_status: pending | verified | rejected
incident_status: pending | under_review | in_progress | resolved | dismissed
incident_priority: low | normal | high | critical
notification_type: status_update | new_message | assignment | broadcast
```

## RLS Policy Summary (What the Client CAN and CANNOT Do)

### ✅ Direct client operations (no Edge Function needed):
- **INSERT incidents** — but ONLY if: user is verified resident (`role=resident`, `is_verified=true`, `verification_status=verified`), `submitted_by = auth.uid()`, `barangay_id = my_barangay_id()`, AND (`is_anonymous=true` + `reporter_id=null`) OR (`is_anonymous=false` + `reporter_id=auth.uid()`)
- **SELECT incidents** — own non-anonymous reports OR any report in own barangay if staff
- **UPDATE incidents** — only barangay staff in own barangay
- **INSERT incident_logs** — staff can add any; residents can add `action='follow_up'` with null statuses on their own non-anonymous reports
- **SELECT incident_logs** — only where `is_public=true` AND (own non-anonymous OR staff)
- **INSERT attachments** — only if `uploaded_by=auth.uid()` AND the parent incident's `submitted_by=auth.uid()`
- **SELECT attachments** — parent incident's reporter (non-anonymous) OR staff
- **SELECT/UPDATE notifications** — own only
- **SELECT users** — own profile OR staff in same barangay
- **UPDATE users** — own profile, but CANNOT change `role` or `barangay_id`
- **SELECT resident_verifications** — own OR staff in same barangay
- **SELECT barangays** — own only

### ❌ Requires an Edge Function (server-side with service-role key):
1. **Create user profile** — no INSERT policy on `users`. Registration flow needs `POST /functions/v1/register-resident`.
2. **Submit resident verification** — no INSERT policy on `resident_verifications`. Same registration function handles this.
3. **Approve/reject verification** — no UPDATE policy on `resident_verifications`. Needs `POST /functions/v1/review-verification`.
4. **Rotate verification status on users** — no UPDATE policy allows changing `verification_status` from client. Handled by `review-verification` function.

## Screens to Build (Route Map)

| Route | Screen | Access |
|---|---|---|
| `/` | Landing | Public |
| `/login` | Login (resident + official tabs) | Public |
| `/register` | Resident registration + ID upload | Public |
| `/verification-pending` | Status gate for unverified users | Authenticated, unverified |
| `/report` | Incident report form (map pin + photo) | Verified resident |
| `/resident` | Resident tracker (own reports list) | Verified resident |
| `/resident/reports/:id` | Incident detail + timeline | Verified resident |
| `/admin` | Operations dashboard (stats) | Staff |
| `/admin/incidents` | Kanban/table incident desk | Staff |
| `/admin/verifications` | ID review queue | Staff |
| `/admin/map` | Interactive operations map | Staff |

## File Structure (Target)

```
lib/
├── main.dart
├── app.dart                          # MaterialApp + GoRouter setup
├── router.dart                       # go_router config with auth guards
├── core/
│   ├── env.dart                      # Supabase URL/anon key loading
│   ├── supabase_client.dart          # Supabase.initialize + singleton
│   ├── theme.dart                    # Colors, typography, dark mode
│   └── constants.dart                # Incident categories, purok list, etc.
├── models/
│   ├── enums.dart                    # All Dart enums with fromString/toDb
│   ├── app_user.dart
│   ├── barangay.dart
│   ├── incident.dart
│   ├── incident_log.dart
│   ├── attachment.dart
│   ├── notification.dart
│   └── resident_verification.dart
├── services/
│   ├── auth_service.dart             # sign in, sign up, session stream
│   ├── user_service.dart             # fetch current profile
│   ├── incident_service.dart         # CRUD + realtime streams
│   ├── storage_service.dart          # upload photos, ID docs
│   ├── notification_service.dart     # FCM + in-app list
│   ├── offline_queue.dart            # Drift-backed queue for pending reports
│   └── edge_functions.dart           # call register-resident, review-verification
├── providers/                        # Riverpod providers
│   ├── auth_provider.dart
│   ├── incident_provider.dart
│   ├── map_provider.dart
│   └── notification_provider.dart
├── screens/
│   ├── landing/
│   ├── auth/
│   ├── verification/
│   ├── report/
│   ├── resident/
│   ├── admin/
│   └── common/                       # SplashScreen, ErrorScreen, LoadingScreen
├── widgets/
│   ├── incident_card.dart
│   ├── incident_marker.dart
│   ├── status_badge.dart
│   ├── priority_badge.dart
│   ├── location_picker.dart
│   └── photo_uploader.dart
└── utils/
    ├── formatters.dart               # Date, reference number formatting
    └── validators.dart               # Zod-equivalent validators
```

## Coding Conventions

1. **No code generation** for models. Write plain Dart classes with `fromMap()` / `toMap()`. Drift is the ONLY permitted code-generation tool, and only for the offline database layer.
2. **Riverpod** for state. Use `AsyncNotifier` and `StreamProvider` where appropriate.
3. **Freezed is optional** — ask before introducing it.
4. **Error handling:** Wrap Supabase calls in try/catch, surface `AuthException` and `PostgrestException` with user-friendly messages.
5. **Null safety:** Strict. No `!` unless certain.
6. **Naming:** snake_case files, PascalCase classes, camelCase variables.
7. **Comments:** Explain non-obvious logic only. No redundant comments.
8. **Always check for connectivity** before inserts. If offline, queue in Drift.
9. **Never log** sensitive data (auth tokens, service keys, user emails in production).

## First Tasks (In Order)

### Task 1: Initialize the project
- Run `flutter create e_sumbong --org ph.gov.palatiw --platforms=android,ios,web`
- Add all dependencies listed above to `pubspec.yaml`
- Create the folder structure above (empty files with placeholder content)
- Create `.env` with `SUPABASE_URL` and `SUPABASE_ANON_KEY` (placeholders)
- Add `.env` to `.gitignore`

### Task 2: Core setup
- `lib/core/env.dart` — load from `--dart-define` or `flutter_dotenv`
- `lib/core/supabase_client.dart` — initialize Supabase, expose client singleton
- `lib/main.dart` — `WidgetsFlutterBinding.ensureInitialized()`, init Supabase, run app

### Task 3: Models + Enums
- Write all files in `lib/models/` per the schema above
- Include `fromMap`, `toInsertMap` where relevant
- Include `copyWith` for mutable models

### Task 4: Auth flow (FIRST WORKING FEATURE)
- `auth_service.dart` — `signIn`, `signUp`, `signOut`, `currentUser` stream
- `auth_provider.dart` — Riverpod provider exposing auth state
- `login_screen.dart` — resident/official tabs, email + password
- `router.dart` — redirect logic: unauthenticated → login; unverified → verification-pending; verified resident → resident; staff → admin

### Task 5: Wait for review
- After Task 4 works end-to-end (login, logout, session persistence), STOP and request review before continuing.

## Rules for You (Codex)

1. **Do not invent database columns.** If a field isn't in the schema above, it doesn't exist.
2. **Do not create Edge Functions yet.** We'll write those in a separate session after the client-side foundation works.
3. **Do not modify RLS or schema.** That's a backend task.
4. **Do not use Firebase for anything except FCM push notifications.** Supabase handles everything else.
5. **Ask before adding a new dependency.** Every dependency is a maintenance cost.
6. **After each task, run `flutter analyze`** and fix all errors before reporting completion.
7. **When you finish a task, summarize:**
   - Files created/modified
   - Commands the user should run to test
   - Any blockers or decisions you made
8. **If something is ambiguous**, ask a specific question rather than guessing.

## Start Here

Begin with Task 1: initialize the Flutter project. Report back when the folder structure and `pubspec.yaml` are set up and `flutter analyze` passes.


## Incident Reference Numbers

- Format: `ES-YYYY-NNNN` (e.g., `ES-2026-0004`)
- Generated by: Postgres column DEFAULT `next_incident_reference()`
- Sequence: global (`incident_reference_seq`), not per-year reset
- **Flutter must NEVER send `reference` on insert.** The DB generates it.
- Display as-is in the UI (e.g., "Report #ES-2026-0004")

## Database Constraints (Enforced by Postgres)

- incidents.title: 5-120 chars
- incidents.description: 20-3000 chars
- incidents.category: exactly one of Constants.incidentCategories:
    'Noise Disturbance', 'Illegal Dumping', 'Public Safety',
    'Infrastructure Damage', 'Emergency'
- incidents.latitude: -90 to 90
- incidents.longitude: -180 to 180
- is_anonymous=true  requires reporter_id IS NULL
- is_anonymous=false requires reporter_id IS NOT NULL (equal to current user)
- incidents.reference is auto-generated; client must never send it