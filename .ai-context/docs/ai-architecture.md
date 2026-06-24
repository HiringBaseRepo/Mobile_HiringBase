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

| Dimension | Field Name | Default Weight (Backend) | Tipe Data |
|---|---|---|---|
| Skill Match | `skill_match_weight` | **40** | Integer (`int`) |
| Experience | `experience_weight` | **20** | Integer (`int`) |
| Education | `education_weight` | **10** | Integer (`int`) |
| Portfolio | `portfolio_weight` | **10** | Integer (`int`) |
| Soft Skills | `soft_skill_weight` | **10** | Integer (`int`) |
| Administrative | `administrative_weight` | **10** | Integer (`int`) |

Seluruh bobot merupakan nilai bilangan bulat (integer) dan **wajib berjumlah tepat 100**. Backend akan menolak penyimpanan template (`WeightTotalInvalidException` / HTTP 400) jika total penjumlahan bobot tersebut tidak sama dengan 100.

### Score Output
- `score`: Integer, range 0–100
- `matchText`: Human-readable label (e.g. `'Top 1%'`, `'Top 5%'`, `'Strong Fit'`, `'Moderate'`)
- Higher score = stronger candidate match for the vacancy

---

## `ScoringService` API Client

**File**: `lib/app/services/scoring_service.dart`
**Base URL**: Konfigurasi dinamis via `.env` (`API_BASE_URL`)
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
ScoringService.saveTemplate()  →  Backend stores template (validated sum = 100)
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

HR dapat menyesuaikan skor AI kandidat secara manual (menggunakan nilai penyesuaian delta per dimensi) melalui modul `manual_override`:

```dart
// Di ManualOverrideController
Future<void> submitOverride() async {
  // 1. Dapatkan application ID dari data candidate
  final appId = int.tryParse(candidate.value!.id);
  if (appId == null) return;

  isLoading.value = true;
  
  try {
    // 2. Kirim parameter penyesuaian delta (misal: skillAdj, expAdj, dll.) ke backend via Query Parameters
    final response = await Get.find<ScoringService>().manualOverride(
      applicationId: appId,
      skillAdjustment: skillAdj.value,
      experienceAdjustment: expAdj.value,
      educationAdjustment: eduAdj.value,
      portfolioAdjustment: portAdj.value,
      softSkillAdjustment: softAdj.value,
      administrativeAdjustment: adminAdj.value,
      reason: reasonController.text,
    );

    isLoading.value = false;

    // 3. Jika sukses, perbarui data lokal dan beri visual feedback
    if (response.statusCode == 200 && response.body != null && response.body['success'] == true) {
      candidate.value = candidate.value!.copyWith(
        score: previewScore.toInt(),
        isManualOverride: true,
      );
      Get.back(result: true);
      Get.snackbar('Success', '⚡ Manual Override applied successfully');
    }
  } catch (e) {
    isLoading.value = false;
  }
}
```

**Spesifikasi Endpoint Manual Override**:
- Path: `POST /api/v1/manual-override/{application_id}`
- Body: `{}` (kosong)
- Query parameters:
  - `skill_adjustment`: float
  - `experience_adjustment`: float
  - `education_adjustment`: float
  - `portfolio_adjustment`: float
  - `soft_skill_adjustment`: float
  - `admin_adjustment`: float (di mapping ke `admin_adjustment` di backend)
  - `reason`: string

**Aturan Tampilan UI**: Kandidat dengan `isManualOverride = true` wajib ditandai secara visual di dalam UI menggunakan badge penunjuk (misalnya, icon penyesuaian manual atau badge warna kuning `AppColors.warning` / `AppColors.interview`).

---

## Ranking Display Logic

Di dalam `AnalyticsController` dan `RankingController`:

```dart
List<Candidate> get rankedCandidates {
  final list = List<Candidate>.from(candidates);
  list.sort((a, b) => b.score.compareTo(a.score));
  return list;
}
```

- Diurutkan menurun (descending) berdasarkan `score`
- Difilter berdasarkan ID Lowongan yang sedang aktif (`selectedJobId`)
- Skor ditampilkan sebagai bilangan bulat disertai label kecocokan (`matchText`)

---

## Fallback Strategy

Strategi penanganan ketika sistem AI mengalami kendala:
1. **API / Inference Unreachable**: Jika backend atau modul AI lambat/tidak terjangkau, controller akan menangkap error via `try-catch` dan menyetel `errorMessage.value`. UI akan merender `ErrorRetryWidget` tanpa membuat aplikasi crash.
2. **Skor AI Gagal Dimuat**: Jika data skor AI tidak terambil, nilai `score` default diatur ke `0` (atau "N/A" pada visual text jika memungkinkan), dan HR tetap diizinkan melakukan review berkas secara manual.
3. **Template Tidak Tersedia**: Jika lowongan baru dibuat dan HR belum mengonfigurasi bobot penilaian template scoring spesifik, backend secara otomatis memakai konfigurasi **Default weights** (`get_default_scoring_template()`) sehingga pipeline screening dan kalkulasi nilai AI tetap dapat dijalankan secara lancar.

---

## Explainability

Backend mengekspos rincian penilaian kecocokan per dimensi di dalam objek `scoring_breakdown`. Halaman detail kandidat (`CandidateDetail`) mengurai data ini untuk menampilkan penjelasan visual yang memudahkan HR:
- **Skill Match**: Menguji kelengkapan skill kandidat berdasarkan deskripsi lowongan.
- **Experience**: Menilai durasi tahun dan relevansi bidang pengalaman kerja.
- **Education**: Membandingkan kecocokan program studi dan tingkat pendidikan (SMA/D3/S1/S2 dll.).
- **Portfolio**: Mengukur kualitas/jumlah tautan bukti karya yang dilampirkan.
- **Soft Skills**: Menganalisis kepribadian/kemampuan komunikasi dari berkas lamaran.
- **Administrative**: Validasi keabsahan 5 dokumen utama yang diunggah pelamar.
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
