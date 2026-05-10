import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/home_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'components/home_header.dart';
import 'components/hr_greeting.dart';
import 'components/hr_stats_row.dart';
import 'components/hr_chart_section.dart';
import 'components/hr_candidates_section.dart';
import 'components/applicant_quick_status_card.dart';
import 'components/applicant_applied_job_card.dart';
import 'components/applicant_ai_match_promo.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = Get.find<AppService>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => appService.isHR ? _buildHRHome() : _buildApplicantHome()),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildHRHome() {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(),
            SizedBox(height: 25),
            HrGreeting(),
            SizedBox(height: 25),
            HrStatsRow(),
            SizedBox(height: 25),
            HrChartSection(),
            SizedBox(height: 25),
            HrCandidatesSection(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantHome() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 32),
            Text(
              'Welcome Back!',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 8),
            Text(
              'Track your career journey and discover new opportunities.',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            const ApplicantQuickStatusCard(),
            const SizedBox(height: 32),
            Text('Recent Applications', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            const ApplicantAppliedJobCard(title: 'Senior UI Designer', company: 'Google', status: 'In Review', color: AppColors.primary),
            const ApplicantAppliedJobCard(title: 'Product Manager', company: 'Vercel', status: 'AI Screening', color: AppColors.secondary),
            const ApplicantAppliedJobCard(title: 'Software Engineer', company: 'Meta', status: 'Interview', color: AppColors.warning),
            const SizedBox(height: 32),
            const ApplicantAiMatchPromo(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
