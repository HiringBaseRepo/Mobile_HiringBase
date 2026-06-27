import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

/// Displays applicant statistics for a job.
///
/// All values default to 0 because the server's `GET /jobs/{id}` endpoint
/// does not yet return applicant stats. They will be populated once the
/// applicant management feature is integrated.
class JobApplicantStatsCard extends StatelessWidget {
  final int total;
  final int newApplicants;
  final int inInterview;
  final double aiScreeningProgress;
  final double technicalTestProgress;

  const JobApplicantStatsCard({
    super.key,
    this.total = 0,
    this.newApplicants = 0,
    this.inInterview = 0,
    this.aiScreeningProgress = 0.0,
    this.technicalTestProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.surface, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Applicant Statistics', style: AppTextStyles.subHeader1),
              if (total == 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'No applicants yet',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatCircle(
                label: 'Total',
                value: total.toString(),
                color: AppColors.primary,
              ),
              _StatCircle(
                label: 'New',
                value: newApplicants.toString(),
                color: AppColors.secondary,
              ),
              _StatCircle(
                label: 'Interview',
                value: inInterview.toString(),
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _StatusProgress(
            label: 'AI Screening',
            progress: aiScreeningProgress,
            color: AppColors.secondary,
            count: (aiScreeningProgress * total).toInt(),
          ),
          const SizedBox(height: 12),
          _StatusProgress(
            label: 'Technical Test',
            progress: technicalTestProgress,
            color: AppColors.info,
            count: (technicalTestProgress * total).toInt(),
          ),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCircle({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(value, style: AppTextStyles.h3.copyWith(color: color)),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _StatusProgress extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  final int count;

  const _StatusProgress({
    required this.label,
    required this.progress,
    required this.color,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyS),
            Text(
              count > 0 ? '$count applicants ($pct%)' : '0 applicants',
              style: AppTextStyles.bodyS.copyWith(
                fontWeight: FontWeight.bold,
                color: count > 0 ? color : AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              count > 0 ? color : AppColors.surface,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
