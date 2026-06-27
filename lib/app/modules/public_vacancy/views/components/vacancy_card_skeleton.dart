import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class VacancyCardSkeleton extends StatelessWidget {
  const VacancyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const SkeletonLoader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonShape.rectangle(width: 200, height: 22, borderRadius: 6),
                SkeletonShape.circle(size: 20),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                SkeletonShape.rectangle(width: 80, height: 20, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonShape.rectangle(width: 100, height: 20, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
