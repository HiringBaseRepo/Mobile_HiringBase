import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';

class CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final int index;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CandidatesController>();

    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: controller.isSelected(candidate.id) && controller.isSelectionMode.value
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: controller.isSelected(candidate.id) && controller.isSelectionMode.value
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (controller.isSelectionMode.value)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => controller.toggleSelection(candidate.id),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller.isSelected(candidate.id)
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: controller.isSelected(candidate.id)
                              ? AppColors.primary
                              : AppColors.textTertiary,
                          width: 2,
                        ),
                      ),
                      child: controller.isSelected(candidate.id)
                          ? const Icon(Icons.check, size: 16, color: AppColors.white)
                          : null,
                    ),
                  ),
                ),
              // show avatar initials if no image URL
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                backgroundImage: candidate.imageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(candidate.imageUrl)
                    : null,
                child: candidate.imageUrl.isEmpty
                    ? Text(
                        candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                        style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
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
                      style: AppTextStyles.subHeader1,
                    ),
                    Text(
                      candidate.role,
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (status) => controller.updateCandidateStatus(candidate.id, status),
                itemBuilder: (context) => [
                  _buildPopupItem('under_review', AppColors.textTertiary),
                  _buildPopupItem('interview', AppColors.primary),
                  _buildPopupItem('hired', AppColors.success),
                  _buildPopupItem('rejected', AppColors.error),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(candidate.statusColor).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        candidate.status,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(candidate.statusColor),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, size: 16, color: Color(candidate.statusColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        value: candidate.score / 100,
                        strokeWidth: 4,
                        backgroundColor: AppColors.textTertiary.withValues(alpha: 0.2),
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
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI SCORE',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        candidate.matchText,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Applied',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      candidate.appliedAt,
                      style: AppTextStyles.bodyS.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/candidate-detail', arguments: {
                      'candidate': candidate,
                      'index': index,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'View Details',
                    style: AppTextStyles.button.copyWith(color: AppColors.cardBackground),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surface),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: AppColors.textTertiary),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  PopupMenuItem<String> _buildPopupItem(String value, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.bodyM.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
