import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

import 'package:uifrontendmobile/app/services/navigation_service.dart';
import '../../controllers/jobs_controller.dart';

class JobPublishSuccessView extends GetView<JobsController> {
  const JobPublishSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSuccessIcon(),
              const SizedBox(height: 30),
              Text(
                "Vacancy Published Successfully!",
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 15),
              Text(
                "Your job listing is now live and ready to receive applications. You can share the link below with potential candidates.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),
              Obx(() {
                final code = controller.publishedApplyCode.value;
                final link = code != null ? 'hiringbase.app/apply/$code' : 'No link generated';
                return Column(
                  children: [
                    _SuccessCard(title: "PUBLIC APPLICATION LINK", value: link, icon: Icons.copy_outlined),
                    const SizedBox(height: 20),
                    _SuccessCard(title: "APPLY CODE", value: code ?? '-', icon: Icons.lock_outline),
                  ],
                );
              }),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.goToJobsList(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text("View Listing", style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.find<NavigationService>().changeTo(0),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.surface),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text("Back to Dashboard", style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SuccessCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
