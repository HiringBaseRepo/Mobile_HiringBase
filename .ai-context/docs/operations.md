# Operations — HiringBase Mobile Frontend

---

## Development Commands

```bash
# Install/restore all dependencies
flutter pub get

# Run the app in debug mode (connected device/emulator)
flutter run

# Run the app on a specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Hot reload (press 'r' in running terminal)
# Hot restart (press 'R' in running terminal)

# Analyze code for lint/type errors
flutter analyze

# Run all tests
flutter test

# Build release APK (Android)
flutter build apk --release

# Build app bundle (Android, for Play Store)
flutter build appbundle --release

# Build release IPA (iOS — requires macOS + Xcode)
flutter build ios --release

# Clean build artifacts
flutter clean

# Check for outdated dependencies
flutter pub outdated

# Upgrade dependencies (minor versions)
flutter pub upgrade
```

---

## Authentication & Session

### HR Authentication
- Login is handled by `LoginController` (module: `login/`)
- On successful login, call `AppService.setUser(user)` to persist session
- `AuthMiddleware` checks `AppService.currentRole.value` on every protected route
- Logout: call `AppService.logout()` then navigate to `Routes.LOGIN`

### Applicant (Public Flow)
- No login required
- Applicant identity is tracked via **Ticket ID** (`TKT-YYYY-XXXXX`)
- No session is stored for applicants — each session is stateless from the app's perspective

### `AuthMiddleware` Behavior
```dart
// Enforces:
// 1. User is logged in (currentUser != null) for HR routes
// 2. Role matches the expected role for the target route
```

---

## Role-Based Access

| Module | Required Role | Middleware Enforced |
|---|---|---|
| All `/home`, `/candidates`, `/jobs-*`, `/ranking`, `/analytics`, etc. | `hr` | Yes |
| `/public-vacancy`, `/track-status` | none (public) | No |
| `/login` | none (public) | No |

---

## API Configuration

- **Base URL**: Dikonfigurasi secara dinamis melalui `.env` (variabel `API_BASE_URL`).
- **Client**: `GetConnect` digunakan di masing-masing service (`JobService`, `AuthService`, `ApplicationService`, `ScoringService`).
- **Auth Token Storage**: Token JWT disimpan secara lokal menggunakan `SharedPreferences` melalui perantara `AppService` (`accessToken` state). Session akan dipulihkan secara otomatis pada saat inisiasi aplikasi (cold-start) melalui pemanggilan `AppService.init()`.
- **Token Refresh Strategy**: Menggunakan masa berlaku JWT standar tanpa auto-refresh di frontend. Jika API mendeteksi token kedaluwarsa (HTTP 401), pengguna (HR) akan diarahkan kembali ke halaman Login.
- **Request Timeout**: Dikonfigurasi secara seragam sebesar 30 detik (`httpClient.timeout = const Duration(seconds: 30)`) di setiap kelas service.

---

## Storage

- **Document Upload Target**: Dokumen pelamar diunggah melalui endpoint `/applications/public/apply` (menggunakan data bertipe `FormData` / multipart). Di backend, berkas disimpan di Cloudflare R2 (S3-Compatible) pada bucket `hirebase-storage`.
- **Upload Path Prefix**: Berkas diunggah di bawah folder prefix `documents/` untuk dokumen persyaratan pelamar, `portfolios/` untuk portfolio, `company-logos/` untuk logo perusahaan, dll.
- **File Size & Type Limits**:
  - Ukuran maksimum berkas adalah **10 MB** per dokumen.
  - Ekstensi file yang diperbolehkan: PDF, JPG, JPEG, PNG, DOC, dan DOCX.
  - Untuk alur pendaftaran pelamar (Applicant), diwajibkan mengunggah 5 dokumen persyaratan utama: Ijazah, KTP, SKCK, Surat Sehat, dan Sertifikat (CV bersifat opsional/diunggah ke kolom portfolio).

---

## Logging

- **Crash/Error Reporting**: Saat ini belum mengintegrasikan alat pelaporan eksternal (seperti Sentry atau Firebase Crashlytics).
- **Log System**: Log debug dicetak menggunakan `debugPrint()` selama proses pengembangan. Penggunaan `print()` secara mentah tidak diperbolehkan. Semua log debug harus dipastikan bersih sebelum aplikasi di-build untuk versi rilis produksi.

---

## Environment Configuration

- **Environment Engine**: Menggunakan paket `flutter_dotenv` untuk membaca file konfigurasi `.env`.
- **File Setup**: File `.env` harus diletakkan di root folder project `Mobile_HiringBase` dan didaftarkan di bagian `assets` pada `pubspec.yaml`.
- **Variable**:
  - `API_BASE_URL`: Menentukan alamat endpoint API backend FastAPI (contoh: `http://localhost:8000/api/v1` untuk lokal, atau `https://api.hiringbase.com/api/v1` untuk staging/produksi).

---

## Build & Release

### Android
1. Ensure `android/app/build.gradle.kts` has correct `applicationId`, `versionCode`, `versionName`
2. Configure signing in `build.gradle.kts` with keystore
3. `flutter build apk --release` or `flutter build appbundle --release`

### iOS
1. Requires macOS + Xcode
2. Configure bundle ID and signing in Xcode
3. `flutter build ios --release`

---

## Code Quality Gates

Before merging any code:

- [ ] `flutter analyze` — zero errors, zero warnings (ideally)
- [ ] `flutter test` — all tests passing
- [ ] No hardcoded colors in widget trees
- [ ] No `print()` statements in production-bound code
- [ ] No `TODO` comments unless tracked in an issue
