import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../routes/app_pages.dart';

class JobActionButtons extends StatelessWidget {
  final String jobId;
  const JobActionButtons({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}

// Helper for consistency
RoundedRectangleBorder _roundedRectangle32() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(32));
}
