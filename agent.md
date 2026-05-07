# Project: SmartScreen AI (Mobile Frontend)

This document serves as the primary context for AI agents working on the SmartScreen AI mobile application. It outlines the project's architecture, design system, and coding standards to ensure consistency across all developments.

## 🚀 Tech Stack
- **Framework**: Flutter (latest stable)
- **Architecture/State Management**: GetX
- **Navigation**: GetX Named Routing
- **UI Components**: Material 3
- **Typography**: Google Fonts (Primary: `Outfit`)
- **Charts**: `fl_chart`
- **Data Handling**: JSON-based mock data (currently)

## 📁 Project Structure (GetX Pattern)
```text
lib/
├── app/
│   ├── data/           # Models, Providers, Repositories
│   ├── modules/        # Feature-based modules
│   │   ├── home/       # Home Dashboard
│   │   ├── candidates/ # Candidate Screening
│   │   └── jobs/       # Job Vacancy Creation (2-step flow)
│   └── routes/         # Routing definitions (app_pages.dart, app_routes.dart)
└── main.dart           # Application entry point
```

## 🎨 Design System & Aesthetics
To maintain the "Premium & State of the Art" feel, adhere to these guidelines:

### 1. Colors
- **Background**: `#F8FAFF` (Light Blueish Gray)
- **Primary**: `#2563EB` (Royal Blue)
- **Secondary**: `#8B5CF6` (Purple/Violet)
- **Success**: `Colors.green`
- **Warning**: `Colors.orange`
- **Text Primary**: `#1E293B` (Dark Slate)
- **Text Secondary**: `#64748B` (Slate Gray)
- **Card Background**: `Colors.white`

### 2. UI Elements
- **Border Radius**: Use `20.0` or `25.0` for cards and major containers.
- **Shadows**: Use subtle shadows: `BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))`
- **Padding**: Standard horizontal padding is `20.0`.
- **Icons**: Use `Icons.outline` variants where possible for a modern look.

### 3. Typography
- Always use `GoogleFonts.outfit()`.
- **Headers**: Bold, size 24-28.
- **Subheaders**: Semi-bold, size 18-20.
- **Body**: Regular, size 14-16.

## 🛠️ Coding Standards
- **GetX Usage**:
    - Use `GetView<Controller>` for views.
    - Keep logic in `Controllers`, UI in `Views`, and dependencies in `Bindings`.
    - Use `Obx(() => ...)` for reactive UI updates.
- **Naming Conventions**:
    - Modules: `snake_case`.
    - Classes: `PascalCase`.
    - Methods/Variables: `camelCase`.
- **Components**: Extract repeatable UI elements (like Candidate Cards) into private methods (e.g., `_buildCandidateCard`) or separate widget files if they grow too large.
- **Routing**: Always use `Get.toNamed(Routes.PATH)` instead of direct widget navigation.

## 🔄 Common Workflows
- **Adding a New Page**: 
    1. Create a new module folder in `lib/app/modules`.
    2. Define the Route in `app_routes.dart` and `app_pages.dart`.
    3. Implement Binding, Controller, and View.
- **Updating UI**: 
    - Ensure new components match the existing "Soft UI / Glassmorphism" aesthetic.
    - Test responsiveness for different screen sizes using `Expanded`, `Flexible`, and `LayoutBuilder` if necessary.

## 🧠 Current Context
The app is currently a high-fidelity recruitment dashboard. It features:
- **Dashboard**: Real-time stats, recruitment trends (Bar Chart), and a quick glance at recent candidates.
- **Candidate Pipeline**: A detailed list of applicants with AI-calculated scores, status badges, and search functionality.
- **Job Creation Flow**: A high-fidelity 2-step wizard:
    1. **Step 1: Job Details**: Basic info, salary range, and key requirements (AI tags).
    2. **Step 2: Applicant Form**: Configurable form fields with AI smart tips and a live "Applicant View" preview.

When adding features, prioritize AI-driven UX elements (e.g., "AI Insights", "Smart Recommendations") to align with the "SmartScreen AI" brand.
