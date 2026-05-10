# Project: SmartScreen AI (Mobile Frontend)

This document serves as the primary context for AI agents working on the SmartScreen AI mobile application. It outlines the project's architecture, design system, and coding standards to ensure consistency and scalability across all developments.

## 🚀 Tech Stack
- **Framework**: Flutter (latest stable)
- **Architecture/State Management**: GetX (Module-based)
- **Navigation**: Centralized `NavigationService` via GetX Named Routing
- **Security**: Role-based `AuthMiddleware`
- **UI Components**: Material 3 (Premium Soft UI / Bento Design)
- **Typography**: Google Fonts (Primary: `Outfit`)
- **Data Handling**: Strong-typed Models (Candidate, Vacancy, User)

## 📁 Project Structure (Scalable GetX Pattern)
```text
lib/
├── app/
│   ├── core/           # Global constants (colors, text styles, themes)
│   │   ├── values/     # app_colors.dart, app_text_styles.dart
│   │   └── widgets/    # Reusable global widgets (app_bottom_nav.dart)
│   ├── data/           # Data layer
│   │   ├── models/     # Type-safe data models (candidate_model.dart, etc.)
│   │   └── repositories/# API/Mock data access (Phase 2)
│   ├── modules/        # Feature-based modules
│   │   └── feature_name/
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   │           ├── feature_view.dart (Main Container)
│   │           └── components/ # MODULAR: Split sub-views/large widgets
│   ├── routes/         # Routing definitions
│   │   ├── app_pages.dart
│   │   ├── app_routes.dart
│   │   └── middlewares/# Route guards (auth_middleware.dart)
│   └── services/       # Global persistent services
│       ├── app_service.dart # Global state (User, Role)
│       └── navigation_service.dart # Routing logic & state
└── main.dart           # Application entry point
```

## 🏗️ Scalability Architecture

### 1. Modular View Pattern
Untuk view yang kompleks (seperti `PublicVacancy` atau `JobCreation`), dilarang keras menulis seluruh kode dalam satu file raksasa. 
- Gunakan folder `views/components/` untuk memecah sub-halaman atau widget besar.
- File view utama (`*_view.dart`) bertindak sebagai *state-driven container* yang mengganti komponen menggunakan `Obx`.

### 2. Global Services
- **`AppService`**: Manages global session state (`currentUser`) and user roles (`hr` vs `applicant`). Access via `Get.find<AppService>()`.
- **`NavigationService`**: Centralizes all navigation logic. Use this instead of direct `Get.toNamed` for primary module switches.

### 3. Route Protection (`AuthMiddleware`)
All internal routes are protected. It enforces role-consistency and prevents unauthorized access to HR dashboards or applicant flows.

### 4. Data Integrity (Models)
**NEVER** use `Map<String, dynamic>` for data passed between controllers and views. Always use strong-typed models defined in `lib/app/data/models/`.

## 🎨 Design System & Bento UI Standards

### 1. Bento Grid Pattern
Gunakan pola Bento (kotak-kotak teratur dengan radius besar) untuk dashboard dan detail view:
- **Border Radius**: Gunakan `24.0` atau `32.0` untuk container Bento.
- **Elevation**: Hindari shadow tebal. Gunakan `BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: Offset(0, 8))`.
- **Spacing**: Gunakan spacing konsisten (gap `12.0` atau `16.0` antar card).

### 2. Color Standardization (`AppColors`)
**MANDATORY**: Dilarang keras hardcoding warna. Gunakan token dari `AppColors`.
- Gunakan `.withValues(alpha: ...)` untuk transparansi (pengganti `withOpacity` yang deprecated).

## 🔄 Public Applicant Flow (Ticket-Based, No Login)
Pelamar **tidak** melakukan login. Alur kerja berbasis tiket (`TKT-YYYY-XXXXX`) untuk pelacakan.
1.  **Step 1 (Job Detail)**: Bento-style detail dengan Hero Card dan Benefits Grid.
2.  **Step 2 (Personal Info)**: Form input data diri (Nama, Email, WhatsApp).
3.  **Step 3 (Document Upload)**: Upload 6 berkas wajib: **CV, Ijazah, KTP, SKCK, Surat Sehat, Sertifikat**.
4.  **Step 4 (Success)**: Konfirmasi dengan generated Ticket ID.

### Validation Rules
- **Required Fields**: Nama, Email, dan WhatsApp wajib terisi.
- **Email Validation**: Harus format email yang valid.
- **Required Docs**: Seluruh 6 dokumen wajib di-upload (feedback visual per item).
- **Duplicate Prevention**: Mock check berdasarkan Email + Vacancy ID.

## 🛠️ Coding Standards
- **Centralized Logic**: Business logic stays in `Controllers`, global state in `Services`.
- **Naming Conventions**:
    - Modules/Files: `snake_case`.
    - Classes: `PascalCase`.
    - Methods/Variables: `camelCase`.
- **Navigation**: Use `NavigationService` for primary navigation. For local/sub-page navigation, use `Get.toNamed(Routes.PATH)`.
- **Reactivity**: Use `Obx(() => ...)` for all UI that depends on `Rx` variables.
- **Color Standardization**: **MANDATORY** use of `AppColors`. Dilarang keras menggunakan hardcoded `Color(0x...)` atau `Colors.white/grey/etc`.
- **Import Policy**: Gunakan **package imports** (`package:uifrontendmobile/app/core/...`) untuk semua referensi ke `core`, `routes`, dan `services` demi konsistensi dan menghindari kesalahan level folder.
- **Data Safety**: Gunakan raw strings (`r'$'`) saat menulis simbol mata uang dalam mock data untuk menghindari error interpolasi.

## 🔄 Completed HR Modules (Phase 1)
1.  **Jobs Management**:
    - `jobs_list`: Daftar lowongan dengan filter status. Menggunakan `Routes.JOBS_LIST`.
    - `job_detail_hr`: Statistik pelamar dan akses manajemen.
2.  **Candidate Selection**:
    - `ranking`: Perankingan kandidat berbasis skor AI.
    - `manual_override`: Penyesuaian skor/status manual.
3.  **Interview Workflow**:
    - `schedule_interview`: Penjadwalan interview (Date/Time/Platform).
    - `interview_detail`: Detail meeting, copy-link, dan integrasi notifikasi.

## 🧠 Current Context
Aplikasi mendukung dual-role:
- **HR (Full Dashboard)**: Seluruh modul inti HR (Jobs, Candidates, Ranking, Interview) telah diimplementasikan dengan Bento UI.
- **Applicant (Public Flow)**: Non-login dengan 2 tab utama (**Jobs** & **Track Status**). Proteksi rute melalui `AuthMiddleware` aktif.
Prioritaskan estetika visual Bento UI, animasi mikro, dan keamanan role dalam setiap pengembangan.
