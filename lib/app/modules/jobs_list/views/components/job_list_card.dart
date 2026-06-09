import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';

class JobListCard extends StatelessWidget {
  final Vacancy job;
  const JobListCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.JOB_DETAIL_HR, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surface, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(status: job.status),
                Text(job.postedAt, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 16),
            Text(job.title, style: AppTextStyles.subHeader1),
            const SizedBox(height: 4),
            Text('${job.department} • ${job.location}', 
              style: AppTextStyles.bodyS.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 20),
            Row(
              children: [
                _StatItem(
                  icon: Icons.people_outline, 
                  label: '${job.applicantCount} Applicants',
                  color: AppColors.primary,
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'published': color = AppColors.success; break;
      case 'draft':     color = AppColors.textTertiary; break;
      case 'closed':    color = AppColors.error; break;
      case 'scheduled': color = AppColors.warning; break;
      case 'private':   color = AppColors.secondary; break;
      default:          color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodyS.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
