import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentCard extends GetView<CandidateDetailController> {
  const DocumentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final candidate = controller.candidate.value;
      if (candidate == null) return const SizedBox();

      final docs = candidate.documents;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ORIGINAL DOCUMENTS',
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
            padding: const EdgeInsets.all(20),
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
            child: docs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.folder_open, size: 40, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text(
                            'No documents uploaded by applicant.',
                            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: docs.map((doc) {
                      final name = doc['file_name']?.toString() ?? 'Unnamed Document';
                      final type = (doc['document_type']?.toString() ?? 'Document').toUpperCase();
                      final url = doc['file_url']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildDocumentItem(name, type, url),
                      );
                    }).toList(),
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildDocumentItem(String fileName, String type, String url) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  type,
                  style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (url.isNotEmpty)
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final uri = Uri.tryParse(url);
                    if (uri != null) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 20, color: AppColors.textSecondary),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Preview Document',
                ),
                IconButton(
                  onPressed: () async {
                    final uri = Uri.tryParse(url);
                    if (uri != null) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.download_outlined, size: 20, color: AppColors.primary),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Download Document',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
