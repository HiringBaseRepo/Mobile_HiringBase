import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/jobs_controller.dart';

class JobNavigationButtons extends StatelessWidget {
  final bool showBack;
  final String nextText;
  final bool isNextEnabled;

  const JobNavigationButtons({
    super.key,
    this.showBack = true,
    this.nextText = "Continue",
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobsController>();

    return Row(
      children: [
        if (showBack)
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.previousStep(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.surface),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Previous"),
            ),
          ),
        if (showBack) const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isNextEnabled ? () => controller.nextStep() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isNextEnabled ? AppColors.primary : AppColors.textTertiary,
              foregroundColor: isNextEnabled ? AppColors.cardBackground : AppColors.textTertiary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(nextText, style: AppTextStyles.button),
          ),
        ),
      ],
    );
  }
}
