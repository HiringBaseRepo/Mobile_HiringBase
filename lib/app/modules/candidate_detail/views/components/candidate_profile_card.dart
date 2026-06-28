import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';

class CandidateProfileCard extends StatelessWidget {
  final Candidate candidate;

  const CandidateProfileCard({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final hasImg = candidate.imageUrl.isNotEmpty;
    final colorVal = Color(candidate.statusColor);

    return Container(
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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorVal.withValues(alpha: 0.2),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: hasImg
                  ? ClipOval(
                      child: Image.network(
                        candidate.imageUrl,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                            style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 32),
                          );
                        },
                      ),
                    )
                  : Text(
                      candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                      style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 32),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            candidate.name,
            style: AppTextStyles.h3.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            candidate.role,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                candidate.statusIndonesian,
                colorVal.withValues(alpha: 0.1),
                colorVal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor,
          fontSize: 10,
        ),
      ),
    );
  }
}
