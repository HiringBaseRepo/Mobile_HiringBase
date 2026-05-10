import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class ApplicantAiMatchPromo extends StatelessWidget {
  const ApplicantAiMatchPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 32),
          const SizedBox(height: 16),
          Text('AI Profile Optimization', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'Our AI suggests improving your "Skills" section to increase your match rate by 25% for Software Engineer roles.',
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
