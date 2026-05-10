import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class JobStepLayout extends StatelessWidget {
  final String title;
  final String step;
  final String sub;
  final double progress;
  final List<Widget> children;

  const JobStepLayout({
    super.key,
    required this.title,
    required this.step,
    required this.sub,
    required this.progress,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(title, step, sub),
            const SizedBox(height: 10),
            _buildProgressBar(progress),
            const SizedBox(height: 25),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String step, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(sub, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Text(step, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3))),
      ),
    );
  }
}
