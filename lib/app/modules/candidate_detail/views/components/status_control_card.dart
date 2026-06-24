import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/candidate_detail_controller.dart';

class StatusControlCard extends GetView<CandidateDetailController> {
  const StatusControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPLICATION CONTROL',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Current Status',
            style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final c = controller.candidate.value;
            final currentStatus = c?.status.toLowerCase() ?? 'applied';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surface, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: CandidateDetailController.statusOptions.any((opt) => opt['value'] == currentStatus) ? currentStatus : 'under_review',
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
                  items: CandidateDetailController.statusOptions
                      .map((opt) => _buildDropItem(opt['value']!, label: opt['label']!))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    if (val == 'rejected') {
                      _showRejectionDialog(context, controller);
                    } else {
                      controller.updateStatus(val);
                    }
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Obx(() {
            final candidate = controller.candidate.value;
            if (candidate == null) return const SizedBox();

            final isScreening = controller.isScreening.value;
            final isPolling = controller.isPolling.value;
            final isUpdating = controller.isUpdatingStatus.value;
            final hasScore = candidate.score > 0;
            final isProcessing = isScreening || isPolling;
            
            if (hasScore && !isPolling) return const SizedBox();
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (isProcessing || isUpdating)
                      ? null
                      : () => controller.runScreening(),
                  icon: isProcessing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.psychology, size: 18),
                  label: Text(isPolling
                      ? 'AI Screening in Progress...'
                      : isProcessing
                          ? 'Processing AI Screening...'
                          : 'Run AI Screening'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            );
          }),
          Obx(() {
            final candidate = controller.candidate.value;
            if (candidate == null) return const SizedBox();
            
            final status = candidate.status.toLowerCase();
            final isUpdating = controller.isUpdatingStatus.value;
            final isScreening = controller.isScreening.value;

            if (status == 'applied' || status == 'doc_check') {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: (isScreening || isUpdating)
                        ? null
                        : () => controller.updateStatus('under_review'),
                    icon: isUpdating
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                        : const Icon(Icons.rate_review_outlined, size: 18),
                    label: const Text('Move to Review (Manual)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.surface),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              );
            }
            
            if (status == 'interview') {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.INTERVIEW_DETAIL, arguments: candidate),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('View Interview Detail'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.SCHEDULE_INTERVIEW, arguments: controller.candidate.value),
                  icon: const Icon(Icons.event, size: 18),
                  label: const Text('Schedule'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Obx(() {
                final candidate = controller.candidate.value;
                if (candidate == null) return const SizedBox();
                final hasScore = candidate.score > 0;
                return Expanded(
                  child: OutlinedButton.icon(
                    onPressed: !hasScore ? null : () async {
                      await Get.toNamed(Routes.MANUAL_OVERRIDE, arguments: candidate);
                      controller.refreshData();
                    },
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Override'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _buildDropItem(String value, {String? label}) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        label ?? value,
        style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
  void _showRejectionDialog(BuildContext context, CandidateDetailController controller) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Text('Alasan Penolakan', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Berikan alasan mengapa kandidat ini ditolak.',
              style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis alasan di sini...',
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.surface),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: AppTextStyles.bodyM,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = textController.text.trim();
              if (reason.isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Alasan penolakan tidak boleh kosong.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                  colorText: AppColors.warning,
                );
                return;
              }
              Navigator.of(context).pop();
              controller.updateStatus('rejected', reason: reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Tolak', style: AppTextStyles.bodyM.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
