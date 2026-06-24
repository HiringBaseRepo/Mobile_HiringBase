import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/candidate_model.dart';
import '../../../../routes/app_pages.dart';

class RankingCard extends StatelessWidget {
  final Candidate candidate;
  final int rank;
  
  const RankingCard({
    super.key,
    required this.candidate,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CANDIDATE_DETAIL, arguments: candidate),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surface, width: 1),
        ),
        child: Row(
          children: [
            _RankIndicator(rank: rank),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(candidate.imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(candidate.name, style: AppTextStyles.subHeader2),
                  Text(candidate.role, style: AppTextStyles.caption),
                ],
              ),
            ),
            _ScoreDisplay(score: candidate.score),
          ],
        ),
      ),
    );
  }
}

class _RankIndicator extends StatelessWidget {
  final int rank;
  const _RankIndicator({required this.rank});

  @override
  Widget build(BuildContext context) {
    final color = switch (rank) {
      1 => AppColors.warning,      // gold
      2 => AppColors.textTertiary, // silver
      3 => const Color(0xFFCD7F32), // bronze
      _ => AppColors.textTertiary,
    };

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Text(
        rank.toString(),
        style: AppTextStyles.bodyM.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final int score;
  const _ScoreDisplay({required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          score.toString(),
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        Text('SCORE', style: AppTextStyles.caption.copyWith(fontSize: 8)),
      ],
    );
  }
}
