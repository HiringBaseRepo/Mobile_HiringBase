import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.description, color: AppColors.primary, size: 20),
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
          child: Column(
            children: [
              _buildDocumentItem('Ijazah_Pendidikan.pdf', 'Updated Oct 24, 2023 • 1.2 MB'),
              const SizedBox(height: 12),
              _buildDocumentItem('Kartu_Tanda_Penduduk.pdf', 'Updated Oct 24, 2023 • 0.8 MB'),
              const SizedBox(height: 12),
              _buildDocumentItem('SKCK_Kepolisian.pdf', 'Updated Oct 24, 2023 • 1.5 MB'),
              const SizedBox(height: 12),
              _buildDocumentItem('Surat_Keterangan_Sehat.pdf', 'Updated Oct 24, 2023 • 0.5 MB'),
              const SizedBox(height: 12),
              _buildDocumentItem('Sertifikat_Keahlian.pdf', 'Updated Oct 24, 2023 • 3.2 MB'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(String fileName, String info) {
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
                  info,
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 20, color: AppColors.textSecondary),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 20, color: AppColors.primary),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
