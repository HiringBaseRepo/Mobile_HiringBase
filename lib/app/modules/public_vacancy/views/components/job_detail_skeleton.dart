import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';

class JobDetailSkeleton extends StatelessWidget {
  const JobDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
        title: const SkeletonLoader(
          child: SkeletonShape.rectangle(width: 100, height: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: SkeletonLoader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bento Hero Skeleton
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.surface, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SkeletonShape.rectangle(width: 40, height: 40, borderRadius: 12),
                        const SizedBox(width: 12),
                        const SkeletonShape.rectangle(width: 120, height: 16),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SkeletonShape.rectangle(width: 250, height: 28),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SkeletonShape.rectangle(width: 80, height: 28, borderRadius: 100),
                        const SizedBox(width: 8),
                        const SkeletonShape.rectangle(width: 90, height: 28, borderRadius: 100),
                        const SizedBox(width: 8),
                        const SkeletonShape.rectangle(width: 100, height: 28, borderRadius: 100),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // About the Role
              Row(
                children: [
                  const SkeletonShape.circle(size: 24),
                  const SizedBox(width: 12),
                  const SkeletonShape.rectangle(width: 120, height: 20),
                ],
              ),
              const SizedBox(height: 16),
              const SkeletonShape.rectangle(width: double.infinity, height: 14),
              const SizedBox(height: 8),
              const SkeletonShape.rectangle(width: double.infinity, height: 14),
              const SizedBox(height: 8),
              const SkeletonShape.rectangle(width: 200, height: 14),
              const SizedBox(height: 32),
              
              // Requirements
              Row(
                children: [
                  const SkeletonShape.circle(size: 24),
                  const SizedBox(width: 12),
                  const SkeletonShape.rectangle(width: 100, height: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SkeletonShape.circle(size: 14),
                  const SizedBox(width: 12),
                  const SkeletonShape.rectangle(width: 180, height: 14),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SkeletonShape.circle(size: 14),
                  const SizedBox(width: 12),
                  const SkeletonShape.rectangle(width: 220, height: 14),
                ],
              ),
              const SizedBox(height: 32),
              
              // Action Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.surface),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonShape.rectangle(width: 150, height: 20),
                    const SizedBox(height: 8),
                    const SkeletonShape.rectangle(width: double.infinity, height: 14),
                    const SizedBox(height: 24),
                    const SkeletonShape.rectangle(width: double.infinity, height: 48, borderRadius: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
