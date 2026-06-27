import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class ApplyFormSubmissionSkeleton extends StatelessWidget {
  const ApplyFormSubmissionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: SkeletonLoader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle Skeletons
            const SkeletonShape.rectangle(width: 180, height: 28),
            const SizedBox(height: 8),
            const SkeletonShape.rectangle(width: 280, height: 16),
            const SizedBox(height: 32),
            
            // Field Group 1
            const SkeletonShape.rectangle(width: 100, height: 16),
            const SizedBox(height: 8),
            const SkeletonShape.rectangle(width: double.infinity, height: 52, borderRadius: 16),
            const SizedBox(height: 20),
            
            // Field Group 2
            const SkeletonShape.rectangle(width: 80, height: 16),
            const SizedBox(height: 8),
            const SkeletonShape.rectangle(width: double.infinity, height: 52, borderRadius: 16),
            const SizedBox(height: 20),
            
            // Field Group 3
            const SkeletonShape.rectangle(width: 120, height: 16),
            const SizedBox(height: 8),
            const SkeletonShape.rectangle(width: double.infinity, height: 52, borderRadius: 16),
            const SizedBox(height: 20),
            
            // Professional Experience Card Mock
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonShape.rectangle(width: 180, height: 20),
                  const SizedBox(height: 24),
                  
                  const SkeletonShape.rectangle(width: 120, height: 14),
                  const SizedBox(height: 12),
                  const SkeletonShape.rectangle(width: double.infinity, height: 96, borderRadius: 16),
                  const SizedBox(height: 24),
                  
                  const SkeletonShape.rectangle(width: 140, height: 14),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SkeletonShape.rectangle(width: 80, height: 32, borderRadius: 100),
                      const SizedBox(width: 8),
                      const SkeletonShape.rectangle(width: 70, height: 32, borderRadius: 100),
                      const SizedBox(width: 8),
                      const SkeletonShape.rectangle(width: 90, height: 32, borderRadius: 100),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
