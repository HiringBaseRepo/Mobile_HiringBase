import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/job_detail_hr_controller.dart';

class JobActionButtons extends StatelessWidget {
  final String jobId;
  const JobActionButtons({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailHrController>();

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(Routes.CANDIDATES, arguments: jobId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: _roundedRectangle32(),
              elevation: 0,
            ),
            child: Text('View All Candidates', style: AppTextStyles.button),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed(Routes.RANKING, arguments: jobId),
                icon: const Icon(Icons.leaderboard_outlined, size: 20),
                label: const Text('Ranking'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.surface),
                  shape: _roundedRectangle32(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed(Routes.CREATE_JOB, arguments: jobId),
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text('Edit Job'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.surface),
                  shape: _roundedRectangle32(),
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          final isClosed = controller.job.value?.status.toLowerCase() == 'closed';
          if (isClosed) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCloseConfirmation(context, controller),
                icon: const Icon(Icons.block, size: 20, color: AppColors.error),
                label: const Text('Close Vacancy'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: _roundedRectangle32(),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showCloseConfirmation(BuildContext context, JobDetailHrController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Close Vacancy?'),
        content: const Text(
          'Are you sure you want to close this job vacancy? Applicants will no longer be able to submit their applications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.closeJob();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Close Job'),
          ),
        ],
      ),
    );
  }
}

// Helper for consistency
RoundedRectangleBorder _roundedRectangle32() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(32));
}
