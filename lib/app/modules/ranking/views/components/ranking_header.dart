import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';

class RankingHeader extends StatelessWidget {
  const RankingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Leaderboard', style: AppTextStyles.h3.copyWith(color: Colors.white)),
              const Icon(Icons.info_outline, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Top candidates ranked by AI assessment and technical scores.',
            style: AppTextStyles.bodyM.copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}
