# AI Architecture — HiringBase Mobile Frontend

> This document covers the AI-powered candidate scoring system used in HiringBase.

---

## Overview

HiringBase uses an AI scoring system to rank job candidates automatically. The mobile frontend interacts with this system through the `ScoringService` API client, which communicates with the FastAPI backend that runs the actual ML inference.

The mobile app's role in the AI pipeline is:
1. **Configure** scoring weights per job (via HR UI)
2. **Display** AI-computed candidate scores and rankings
3. **Allow** manual overrides by HR users
4. **Show** explainability information (match text, score breakdown)

---

## Scoring System

### Weight Configuration
Each job vacancy has a configurable scoring template. HR users set weights for 6 dimensions:

| Dimension | Field Name | Default |
|---|---|---|
| Skill Match | `skill_match_weight` | [PERLU DIISI] |
| Experience | `experience_weight` | [PERLU DIISI] |
| Education | `education_weight` | [PERLU DIISI] |
| Portfolio | `portfolio_weight` | [PERLU DIISI] |
| Soft Skills | `soft_skill_weight` | [PERLU DIISI] |
| Administrative | `administrative_weight` | [PERLU DIISI] |

All weights are floating-point values. [PERLU DIISI] — Confirm if they must sum to 1.0 or 100.

### Score Output
- `score`: Integer, range 0–100
- `matchText`: Human-readable label (e.g. `'Top 1%'`, `'Top 5%'`, `'Strong Fit'`, `'Moderate'`)
- Higher score = stronger candidate match for the vacancy

---

## `ScoringService` API Client

**File**: `lib/app/services/scoring_service.dart`
**Base URL**: `http://api.hiringbase.com/api/v1`
**Type**: `GetConnect`

### Endpoints

```dart
// Fetch existing scoring template for a job
GET  /scoring/templates/{jobId}
→ getTemplate(jobId)

// Create a new scoring template
POST /scoring/templates
→ saveTemplate({jobId, skillMatch, experience, education, portfolio, softSkill, administrative})

// Update an existing template
PATCH /scoring/templates/{templateId}
→ updateTemplate(templateId, weights)
```

---

## Mobile-Side Pipeline

```
HR sets weights
      ↓
ScoringService.saveTemplate()  →  Backend stores template
      ↓
Backend runs AI inference on all candidates for that job
      ↓
Candidate.score & Candidate.matchText populated on next fetch
      ↓
RankingController.rankedCandidates  (sorted desc by score)
      ↓
RankingView displays sorted list with score badges
```

---

## Manual Override

HR can bypass AI scores via the `manual_override` module:

```dart
// In ManualOverrideController (or equivalent)
void overrideScore(String candidateId, int newScore) {
  final idx = candidates.indexWhere((c) => c.id == candidateId);
  if (idx == -1) return;
  candidates[idx] = candidates[idx].copyWith(
    score: newScore,
    isManualOverride: true,
  );
  // [PERLU DIISI] — persist override to backend
}
```

**UI Rule**: Candidates with `isManualOverride = true` must always be visually distinguished (e.g. an "Override" badge with `AppColors.warning` or `AppColors.interview`).

---

## Ranking Display Logic

In `AnalyticsController` and `RankingController`:

```dart
List<Candidate> get rankedCandidates {
  final list = List<Candidate>.from(candidates);
  list.sort((a, b) => b.score.compareTo(a.score));
  return list;
}
```

- Sorted descending by `score`
- Filtered by selected job (`filteredCandidates` based on `selectedJobId`)
- Score displayed as integer + matchText label

---

## Fallback Strategy

[PERLU DIISI] — Define the fallback when:
- AI inference API is unreachable
- `ScoringService` returns a non-2xx response
- Scoring template does not exist for a job

**Suggested approach**:
- Display a "Score Unavailable" placeholder instead of `0`
- Allow HR to still manually review and override
- Log the error via `debugPrint` or crash reporter in debug mode

---

## Explainability

[PERLU DIISI] — Confirm if the backend exposes per-dimension score breakdowns.

If available, the `CandidateDetail` view should display a breakdown:
```
Skill Match:    85/100
Experience:     90/100
Education:      78/100
Portfolio:      72/100
Soft Skills:    88/100
Administrative: 95/100
─────────────────────
Overall Score:  85/100 (weighted)
```
