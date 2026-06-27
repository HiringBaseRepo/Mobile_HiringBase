import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/data/models/interview_model.dart';
import '../controllers/interview_detail_controller.dart';

class InterviewDetailView extends GetView<InterviewDetailController> {
  const InterviewDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text('Interview Detail', style: AppTextStyles.subHeader1),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _MainInfoCard(data: controller.interviewData.value),
              const SizedBox(height: 24),
              _LinkCard(link: controller.interviewData.value.link),
              const SizedBox(height: 48),
            ],
          ),
        );
      }),
    );
  }
}

class _MainInfoCard extends StatelessWidget {
  final Interview data;
  const _MainInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isNotScheduled = data.status.toLowerCase() == 'not scheduled';
    final tagColor = isNotScheduled ? AppColors.textSecondary : AppColors.success;
    final tagBgColor = isNotScheduled ? AppColors.surface : AppColors.success.withValues(alpha: 0.1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tagBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data.status.toUpperCase(),
              style: AppTextStyles.caption.copyWith(color: tagColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Text(data.candidateName, style: AppTextStyles.h2),
          Text(data.role, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          _DetailRow(icon: Icons.calendar_today_outlined, label: data.date),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.access_time_outlined, label: data.time),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.videocam_outlined, label: data.platform),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textTertiary),
        const SizedBox(width: 16),
        Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _LinkCard extends StatelessWidget {
  final String link;
  const _LinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
    final bool hasLink = link != '-' && link.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hasLink ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: hasLink ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meeting Link', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  link,
                  style: AppTextStyles.bodyM.copyWith(
                    color: hasLink ? AppColors.primary : AppColors.textSecondary,
                    decoration: hasLink ? TextDecoration.underline : TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasLink)
                IconButton(
                  icon: const Icon(Icons.copy, size: 20, color: AppColors.primary),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: link));
                    Get.snackbar('Copied', 'Meeting link copied to clipboard');
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: hasLink ? () {} : null, // Launch URL
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Join Meeting Now'),
            ),
          ),
        ],
      ),
    );
  }
}
