import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationDataCard extends GetView<CandidateDetailController> {
  const ApplicationDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final candidate = controller.candidate.value;
      if (candidate == null) return const SizedBox();

      final answers = candidate.answers;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'APPLICATION DATA',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem('FULL NAME', candidate.name),
                const SizedBox(height: 20),
                _buildInfoItem('EMAIL', candidate.email ?? '-'),
                const SizedBox(height: 20),
                _buildInfoItem('APPLIED FOR', candidate.role),
                const SizedBox(height: 20),
                _buildInfoItem('APPLIED DATE', candidate.appliedAt),

                if (answers.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: AppColors.surface),
                  const SizedBox(height: 24),
                  Text(
                    'FORM SUBMISSIONS / ANSWERS',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...answers.map((ans) {
                    final label = (ans['label'] as String? ?? ans['field_key'] ?? '').toUpperCase();
                    final val = ans['value']?.toString() ?? '-';
                    final isUrl = val.startsWith('http://') || val.startsWith('https://');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isUrl)
                            InkWell(
                              onTap: () async {
                                final uri = Uri.tryParse(val);
                                if (uri != null) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      val,
                                      style: AppTextStyles.bodyM.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                                ],
                              ),
                            )
                          else
                            Text(
                              val,
                              style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
