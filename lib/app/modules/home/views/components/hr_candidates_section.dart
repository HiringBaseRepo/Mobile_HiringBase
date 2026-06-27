import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/core/widgets/skeleton_loader.dart';
import '../../controllers/home_controller.dart';

class HrCandidatesSection extends StatelessWidget {
  const HrCandidatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Candidates',
              style: AppTextStyles.subHeader1,
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.CANDIDATES);
              },
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return const Column(
              children: [
                HomeCandidateCardSkeleton(),
                HomeCandidateCardSkeleton(),
              ],
            );
          }

          if (controller.candidates.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.surface, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 40, color: AppColors.textTertiary),
                  const SizedBox(height: 12),
                  Text(
                    'No candidates applied yet.',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: controller.candidates
                .asMap()
                .entries
                .map((e) => _HomeCandidateCard(candidate: e.value, index: e.key))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _HomeCandidateCard extends StatelessWidget {
  final Candidate candidate;
  final int index;

  const _HomeCandidateCard({
    required this.candidate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final hasImg = candidate.imageUrl.isNotEmpty;
    final colorVal = Color(candidate.statusColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: hasImg ? NetworkImage(candidate.imageUrl) : null,
                child: !hasImg
                    ? Text(
                        candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                        style: AppTextStyles.subHeader2.copyWith(color: AppColors.primary),
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: AppTextStyles.subHeader2,
                    ),
                    Text(
                      candidate.role,
                      style: AppTextStyles.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorVal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  candidate.status.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorVal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: candidate.score / 100,
                        strokeWidth: 3,
                        backgroundColor: AppColors.background,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      candidate.score.toString(),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  candidate.score > 0 ? candidate.matchText : 'AI Screening Pending',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/candidate-detail', arguments: {
                  'candidate': candidate,
                  'index': index,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.accentText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Details',
                style: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCandidateCardSkeleton extends StatelessWidget {
  const HomeCandidateCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const SkeletonLoader(
        child: Column(
          children: [
            Row(
              children: [
                SkeletonShape.circle(size: 48),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonShape.rectangle(width: 120, height: 16),
                      SizedBox(height: 6),
                      SkeletonShape.rectangle(width: 80, height: 12),
                    ],
                  ),
                ),
                SkeletonShape.rectangle(width: 70, height: 20, borderRadius: 10),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                SkeletonShape.circle(size: 32),
                SizedBox(width: 12),
                SkeletonShape.rectangle(width: 130, height: 14),
              ],
            ),
            SizedBox(height: 12),
            SkeletonShape.rectangle(width: double.infinity, height: 40, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
