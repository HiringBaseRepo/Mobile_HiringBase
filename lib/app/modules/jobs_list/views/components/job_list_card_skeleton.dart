import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class JobListCardSkeleton extends StatelessWidget {
  const JobListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                SkeletonShape.rectangle(width: 80, height: 18, borderRadius: 8),
                SkeletonShape.rectangle(width: 60, height: 14, borderRadius: 4),
              ],
            ),
            SizedBox(height: 16),
            SkeletonShape.rectangle(width: 180, height: 22, borderRadius: 6),
            SizedBox(height: 8),
            SkeletonShape.rectangle(width: 120, height: 16, borderRadius: 4),
            SizedBox(height: 24),
            Row(
              children: [
                SkeletonShape.rectangle(width: 100, height: 16, borderRadius: 4),
                Spacer(),
                SkeletonShape.circle(size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
