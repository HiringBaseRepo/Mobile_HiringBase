import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import '../controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'components/job_core_step.dart';
import 'components/requirement_builder_step.dart';
import 'components/applicant_form_setup_step.dart';
import 'components/publish_control_step.dart';
import 'components/job_publish_success_view.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.currentStep.value) {
          case 1: return const JobCoreStep();
          case 2: return const RequirementBuilderStep();
          case 3: return const ApplicantFormSetupStep();
          case 4: return const PublishControlStep();
          case 5: return const JobPublishSuccessView();
          default: return const JobCoreStep();
        }
      }),
      bottomNavigationBar: Obx(() => controller.currentStep.value == 5 
          ? const SizedBox.shrink() 
          : const AppBottomNav()),
    );
  }
}
