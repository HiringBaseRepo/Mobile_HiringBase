# Domain Rules — HiringBase Mobile Frontend

---

## Core Entities

### `User`
**File**: `lib/app/data/models/user_model.dart`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique user identifier |
| `name` | `String` | Display name |
| `email` | `String` | Login email |
| `role` | `String` | `'hr'` or `'applicant'` |

---

### `Vacancy`
**File**: `lib/app/data/models/vacancy_model.dart`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique vacancy ID |
| `title` | `String` | Job title |
| `department` | `String` | Department name |
| `location` | `String` | Job location |
| `type` | `String` | Employment type (full-time, part-time, etc.) |
| `salary` | `String` | Salary range string |
| `description` | `String` | Full job description |
| `requirements` | `List<String>` | List of qualifications |
| `docs` | `List<String>` | Required application documents |
| `status` | `String` | `'draft'` \| `'published'` \| `'closed'` |
| `applicantCount` | `int` | Number of applicants |
| `postedAt` | `String` | Creation/post date string |

---

### `Candidate`
**File**: `lib/app/data/models/candidate_model.dart`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique candidate ID |
| `name` | `String` | Full name |
| `role` | `String` | Applied position title |
| `status` | `String` | Current pipeline stage |
| `score` | `int` | AI-computed score (0–100) |
| `matchText` | `String` | Human-readable match label (e.g. `'Top 5%'`) |
| `appliedAt` | `String` | Relative time string |
| `imageUrl` | `String` | Avatar URL |
| `statusColor` | `int` | ARGB color int for status badge |
| `isManualOverride` | `bool` | True if HR manually adjusted this score |

---

## Status Flows

### Vacancy Status
```
draft → published → closed
```
- Only `published` vacancies are visible in the public applicant view.
- `draft` vacancies are only visible to HR in the jobs list.
- `closed` vacancies accept no new applications.

### Candidate Pipeline Status
```
Applied → Reviewed → Interview → Accepted
                              → Rejected
```
- Status transitions are HR-initiated.
- `isManualOverride = true` means the score was manually set by HR (bypassing AI ranking).
- UI must visually distinguish overridden candidates (e.g. a badge or icon).

### AI Scoring Weights
Configured per-job via `ScoringService`. All weights are floating-point percentages:
- `skill_match_weight`
- `experience_weight`
- `education_weight`
- `portfolio_weight`
- `soft_skill_weight`
- `administrative_weight`

---

## Business Rules

### Public Applicant Flow

Applicants do **not** create accounts or log in. The flow is:

1. Browse published vacancies (public, no auth)
2. View job detail
3. Fill personal info form:
   - **Name** — required
   - **Email** — required, must be valid format
   - **WhatsApp** — required
4. Upload 6 mandatory documents:
   - CV, Ijazah, KTP, SKCK, Surat Sehat, Sertifikat
   - Each document must show individual visual upload feedback
   - All 6 must be uploaded before submission
5. Receive Ticket ID on success (format: `TKT-YYYY-XXXXX`)

**Duplicate Prevention**: Check Email + Vacancy ID combination before allowing submission.

### HR Flow Rules

- HR users must be authenticated (login required).
- Access to HR modules is enforced by `AuthMiddleware`.
- Manual score override must set `isManualOverride = true` on the Candidate model.
- Ranking is sorted descending by `score` (highest first).
- Interview scheduling requires: Date, Time, Platform.

---

## Route Catalog

| Route Constant | Path | Role |
|---|---|---|
| `Routes.HOME` | `/home` | HR |
| `Routes.CANDIDATES` | `/candidates` | HR |
| `Routes.JOBS_LIST` | `/jobs-list` | HR |
| `Routes.CREATE_JOB` | `/create-job` | HR |
| `Routes.JOB_DETAIL_HR` | `/job-detail-hr` | HR |
| `Routes.CANDIDATE_DETAIL` | `/candidate-detail` | HR |
| `Routes.ANALYTICS` | `/analytics` | HR |
| `Routes.PROFILE` | `/profile` | HR |
| `Routes.SELECTION` | `/selection` | HR |
| `Routes.RANKING` | `/ranking` | HR |
| `Routes.MANUAL_OVERRIDE` | `/manual-override` | HR |
| `Routes.SCHEDULE_INTERVIEW` | `/schedule-interview` | HR |
| `Routes.INTERVIEW_DETAIL` | `/interview-detail` | HR |
| `Routes.NOTIFICATIONS` | `/notifications` | HR |
| `Routes.AKTIVITAS` | `/aktivitas` | HR |
| `Routes.SETTINGS` | `/settings` | HR |
| `Routes.LOGIN` | `/login` | Public |
| `Routes.PUBLIC_VACANCY` | `/public-vacancy` | Applicant |
| `Routes.TRACK_STATUS` | `/track-status` | Applicant |

---

## API Response Convention

> [PERLU DIISI] — Confirm the actual API response envelope from the backend team.

Expected pattern (based on HiringBase backend conventions):
```json
{
  "success": true,
  "message": "Operation completed",
  "data": { ... },
  "errors": null,
  "meta": { "page": 1, "total": 45 }
}
```

All `fromJson` factories in models should be written to unwrap `data` before parsing.

---

## Error Handling Convention

> [PERLU DIISI] — Define a consistent error handling strategy for API failures.

Suggested approach:
- Services return `Response` objects from `GetConnect`
- Controllers check `response.status.hasError` before using `response.body`
- Display errors via `Get.snackbar('Error', response.statusText ?? 'Unknown error')`
- Do not let uncaught exceptions propagate to views
