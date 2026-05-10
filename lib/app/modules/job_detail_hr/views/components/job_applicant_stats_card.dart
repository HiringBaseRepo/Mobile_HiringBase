import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';

class JobApplicantStatsCard extends StatelessWidget {
  final int total;
  const JobApplicantStatsCard({super.key, required this.total});

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
          Text('Applicant Statistics', style: AppTextStyles.subHeader1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatCircle(label: 'Total', value: total.toString(), color: AppColors.primary),
              _StatCircle(label: 'New', value: '12', color: AppColors.secondary),
              _StatCircle(label: 'Interview', value: '4', color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),
          const _StatusProgress(label: 'AI Screening', progress: 0.65, color: Colors.purple),
          const SizedBox(height: 12),
          const _StatusProgress(label: 'Technical Test', progress: 0.30, color: Colors.blue),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCircle({required this.label, required this.value, required this.color});

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

  const _StatusProgress({required this.label, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyS),
            Text('${(progress * 100).toInt()}%', style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
