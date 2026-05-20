import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/candidates/bindings/candidates_binding.dart';
import '../modules/candidates/views/candidates_view.dart';
import '../modules/jobs/bindings/jobs_binding.dart';
import '../modules/jobs/views/jobs_view.dart';
import '../modules/candidate_detail/bindings/candidate_detail_binding.dart';
import '../modules/candidate_detail/views/candidate_detail_view.dart';
import '../modules/analytics/bindings/analytics_binding.dart';
import '../modules/analytics/views/analytics_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/aktivitas_view.dart';
import '../modules/selection/bindings/selection_binding.dart';
import '../modules/selection/views/selection_view.dart';
import '../modules/public_vacancy/bindings/public_vacancy_binding.dart';
import '../modules/public_vacancy/views/public_vacancy_view.dart';
import '../modules/public_vacancy/views/components/track_status_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/jobs_list/bindings/jobs_list_binding.dart';
import '../modules/jobs_list/views/jobs_list_view.dart';
import '../modules/job_detail_hr/bindings/job_detail_hr_binding.dart';
import '../modules/job_detail_hr/views/job_detail_hr_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/ranking/bindings/ranking_binding.dart';
import '../modules/ranking/views/ranking_view.dart';
import '../modules/manual_override/bindings/manual_override_binding.dart';
import '../modules/manual_override/views/manual_override_view.dart';
import '../modules/schedule_interview/bindings/schedule_interview_binding.dart';
import '../modules/schedule_interview/views/schedule_interview_view.dart';
import '../modules/interview_detail/bindings/interview_detail_binding.dart';
import '../modules/interview_detail/views/interview_detail_view.dart';

import '../routes/middlewares/auth_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SELECTION;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CANDIDATES,
      page: () => const CandidatesView(),
      binding: CandidatesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CREATE_JOB,
      page: () => const JobsView(),
      binding: JobsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.JOBS_LIST,
      page: () => const JobsListView(),
      binding: JobsListBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.JOB_DETAIL_HR,
      page: () => const JobDetailHrView(),
      binding: JobDetailHrBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CANDIDATE_DETAIL,
      page: () => const CandidateDetailView(),
      binding: CandidateDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ANALYTICS,
      page: () => const AnalyticsView(),
      binding: AnalyticsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SELECTION,
      page: () => const SelectionView(),
      binding: SelectionBinding(),
    ),
    GetPage(
      name: _Paths.PUBLIC_VACANCY,
      page: () => const PublicVacancyView(),
      binding: PublicVacancyBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.TRACK_STATUS,
      page: () => const TrackStatusView(),
      binding: PublicVacancyBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.RANKING,
      page: () => const RankingView(),
      binding: RankingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.MANUAL_OVERRIDE,
      page: () => const ManualOverrideView(),
      binding: ManualOverrideBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SCHEDULE_INTERVIEW,
      page: () => const ScheduleInterviewView(),
      binding: ScheduleInterviewBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.INTERVIEW_DETAIL,
      page: () => const InterviewDetailView(),
      binding: InterviewDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.AKTIVITAS,
      page: () => const AktivitasView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
