import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class CandidateDetailSkeleton extends StatelessWidget {
  const CandidateDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SkeletonLoader(
        child: Column(
          children: [
            // Profile Card Skeleton
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Circle Avatar
                  const SkeletonShape.circle(size: 96),
                  const SizedBox(height: 16),
                  // Candidate Name
                  const SkeletonShape.rectangle(width: 160, height: 24),
                  const SizedBox(height: 8),
                  // Candidate Role
                  const SkeletonShape.rectangle(width: 120, height: 16),
                  const SizedBox(height: 16),
                  // Status Badge
                  const SkeletonShape.rectangle(width: 80, height: 24, borderRadius: 999),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Application Data Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      const SkeletonShape.circle(size: 20),
                      const SizedBox(width: 8),
                      const SkeletonShape.rectangle(width: 140, height: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      const SkeletonShape.rectangle(width: 80, height: 10),
                      const SizedBox(height: 6),
                      const SkeletonShape.rectangle(width: 180, height: 16),
                      const SizedBox(height: 20),
                      // Email
                      const SkeletonShape.rectangle(width: 60, height: 10),
                      const SizedBox(height: 6),
                      const SkeletonShape.rectangle(width: 220, height: 16),
                      const SizedBox(height: 20),
                      // Applied For
                      const SkeletonShape.rectangle(width: 90, height: 10),
                      const SizedBox(height: 6),
                      const SkeletonShape.rectangle(width: 150, height: 16),
                      const SizedBox(height: 20),
                      // Applied Date
                      const SkeletonShape.rectangle(width: 90, height: 10),
                      const SizedBox(height: 6),
                      const SkeletonShape.rectangle(width: 120, height: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Original Documents Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      const SkeletonShape.circle(size: 20),
                      const SizedBox(width: 8),
                      const SkeletonShape.rectangle(width: 160, height: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Document item 1
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surface, width: 1),
                        ),
                        child: Row(
                          children: [
                            const SkeletonShape.rectangle(width: 40, height: 40, borderRadius: 8),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SkeletonShape.rectangle(width: 120, height: 14),
                                  const SizedBox(height: 6),
                                  const SkeletonShape.rectangle(width: 60, height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Document item 2
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surface, width: 1),
                        ),
                        child: Row(
                          children: [
                            const SkeletonShape.rectangle(width: 40, height: 40, borderRadius: 8),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SkeletonShape.rectangle(width: 150, height: 14),
                                  const SizedBox(height: 6),
                                  const SkeletonShape.rectangle(width: 80, height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Control Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  SkeletonShape.rectangle(width: double.infinity, height: 48, borderRadius: 16),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
