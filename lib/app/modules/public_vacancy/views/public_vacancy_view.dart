import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import '../controllers/public_vacancy_controller.dart';
import 'components/vacancy_list_view.dart';
import 'components/job_detail_view.dart';
import 'components/apply_form_view.dart';
import 'components/apply_success_view.dart';
import 'components/track_status_view.dart';

class PublicVacancyView extends GetView<PublicVacancyController> {
  const PublicVacancyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedVacancy = controller.selectedVacancy.value;
      final currentStep = controller.currentStep.value;

      // Container logic for module navigation
      return Scaffold(
        body: _buildCurrentView(selectedVacancy, currentStep),
        bottomNavigationBar: (selectedVacancy == null) 
            ? const AppBottomNav() 
            : null,
      );
    });
  }

  Widget _buildCurrentView(dynamic selectedVacancy, int currentStep) {
    if (selectedVacancy == null) {
      return const VacancyListView();
    }

    switch (currentStep) {
      case 1:
        return const JobDetailView();
      case 2:
      case 3:
        return const ApplyFormView();
      case 4:
        return const ApplySuccessView();
      case 5:
        return const TrackStatusView();
      default:
        return const VacancyListView();
    }
  }
}
