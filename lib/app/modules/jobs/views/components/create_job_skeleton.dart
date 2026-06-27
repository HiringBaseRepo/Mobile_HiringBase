import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class CreateJobSkeleton extends StatelessWidget {
  const CreateJobSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SkeletonLoader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SkeletonShape.rectangle(width: 80, height: 16),
            const SizedBox(height: 12),
            const SkeletonShape.rectangle(width: 220, height: 28),
            const SizedBox(height: 8),
            const SkeletonShape.rectangle(width: 160, height: 14),
            const SizedBox(height: 32),
            
            // Step Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => Row(
                children: [
                  const SkeletonShape.circle(size: 32),
                  if (index < 3) ...[
                    const SizedBox(width: 8),
                    const SkeletonShape.rectangle(width: 30, height: 2),
                    const SizedBox(width: 8),
                  ]
                ],
              )),
            ),
            const SizedBox(height: 40),
            
            // Section Card Mock
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
                  const SkeletonShape.rectangle(width: 140, height: 20),
                  const SizedBox(height: 8),
                  const SkeletonShape.rectangle(width: double.infinity, height: 14),
                  const SizedBox(height: 28),
                  
                  // Label & Field 1
                  const SkeletonShape.rectangle(width: 100, height: 16),
                  const SizedBox(height: 8),
                  const SkeletonShape.rectangle(width: double.infinity, height: 48, borderRadius: 12),
                  const SizedBox(height: 24),
                  
                  // Label & Field 2
                  const SkeletonShape.rectangle(width: 120, height: 16),
                  const SizedBox(height: 8),
                  const SkeletonShape.rectangle(width: double.infinity, height: 100, borderRadius: 12),
                  const SizedBox(height: 24),
                  
                  // Row fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SkeletonShape.rectangle(width: 80, height: 16),
                            const SizedBox(height: 8),
                            const SkeletonShape.rectangle(width: double.infinity, height: 48, borderRadius: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SkeletonShape.rectangle(width: 80, height: 16),
                            const SizedBox(height: 8),
                            const SkeletonShape.rectangle(width: double.infinity, height: 48, borderRadius: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: const SkeletonShape.rectangle(height: 48, borderRadius: 12),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: const SkeletonShape.rectangle(height: 48, borderRadius: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
