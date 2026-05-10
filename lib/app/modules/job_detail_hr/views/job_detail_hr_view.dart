import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/job_detail_hr_controller.dart';
import 'components/job_info_card.dart';
import 'components/job_applicant_stats_card.dart';
import 'components/job_action_buttons.dart';

class JobDetailHrView extends GetView<JobDetailHrController> {
  const JobDetailHrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text('Job Detail', style: AppTextStyles.subHeader1),
        centerTitle: true,
      ),
      body: Obx(() {
        final job = controller.job.value;
        if (job == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              JobInfoCard(job: job),
              const SizedBox(height: 24),
              JobApplicantStatsCard(total: job.applicantCount),
              const SizedBox(height: 24),
              JobActionButtons(jobId: job.id),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
