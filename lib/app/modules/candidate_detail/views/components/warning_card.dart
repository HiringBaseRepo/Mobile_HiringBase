import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class ParsedWarning {
  final String category;
  final String cleanMessage;
  final String? documentName;
  final String? applicantName;
  final String? extraNote;

  ParsedWarning({
    required this.category,
    required this.cleanMessage,
    this.documentName,
    this.applicantName,
    this.extraNote,
  });

  factory ParsedWarning.parse(String message) {
    String cleanMessage = message.trim();
    String category = 'PERINGATAN';
    String? docName;
    String? appName;
    String? extra;

    // 1. Strip and parse technical category prefix if any (e.g. "Warning degree:")
    final lowerMsg = cleanMessage.toLowerCase();
    if (lowerMsg.startsWith('warning ')) {
      final colonIndex = cleanMessage.indexOf(':');
      if (colonIndex != -1) {
        final prefix = cleanMessage.substring(8, colonIndex).trim().toLowerCase();
        cleanMessage = cleanMessage.substring(colonIndex + 1).trim();
        
        switch (prefix) {
          case 'degree':
            category = 'IJAZAH';
            break;
          case 'identity_card':
            category = 'KTP';
            break;
          case 'criminal_record':
            category = 'SKCK';
            break;
          case 'health_certificate':
            category = 'SURAT KESEHATAN';
            break;
          default:
            category = prefix.toUpperCase().replaceAll('_', ' ');
        }
      }
    } else {
      // General fallbacks based on text content
      if (lowerMsg.contains('ijazah')) {
        category = 'IJAZAH';
      } else if (lowerMsg.contains('ktp') || lowerMsg.contains('identitas')) {
        category = 'KTP';
      } else if (lowerMsg.contains('skck')) {
        category = 'SKCK';
      }
    }

    // 2. Extract names inside parentheses (e.g. (AHMAD RIZKY PRATAMA) and (BUDI SANTOSO))
    final regex = RegExp(r'\(([^)]+)\)');
    final matches = regex.allMatches(cleanMessage).toList();
    if (matches.length >= 2) {
      docName = matches[0].group(1);
      appName = matches[1].group(1);
      
      // Extract extra note after the first sentence
      final dotIndex = cleanMessage.indexOf('.');
      if (dotIndex != -1 && dotIndex < cleanMessage.length - 1) {
        extra = cleanMessage.substring(dotIndex + 1).trim();
      }
    }

    // 3. If there are no parenthesized names, check if there is a dot separating a subtext
    if (docName == null && cleanMessage.contains('.')) {
      final dotIndex = cleanMessage.indexOf('.');
      if (dotIndex < cleanMessage.length - 1) {
        extra = cleanMessage.substring(dotIndex + 1).trim();
        cleanMessage = cleanMessage.substring(0, dotIndex).trim();
      }
    }

    return ParsedWarning(
      category: category,
      cleanMessage: cleanMessage,
      documentName: docName,
      applicantName: appName,
      extraNote: extra,
    );
  }
}

class WarningCard extends StatelessWidget {
  final String rawMessage;

  const WarningCard({
    super.key,
    required this.rawMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (rawMessage.trim().isEmpty) return const SizedBox.shrink();

    final parsed = ParsedWarning.parse(rawMessage);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Accent Line
              Container(
                width: 4,
                color: AppColors.error,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Warning Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                parsed.category,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Structured mismatch fields or plain message
                            if (parsed.documentName != null && parsed.applicantName != null) ...[
                              _buildInfoRow(
                                icon: Icons.description_outlined,
                                label: 'Nama di Dokumen:',
                                value: parsed.documentName!,
                                isHighlight: true,
                              ),
                              const SizedBox(height: 6),
                              _buildInfoRow(
                                icon: Icons.person_outline_rounded,
                                label: 'Nama Pelamar:',
                                value: parsed.applicantName!,
                                isHighlight: false,
                              ),
                            ] else ...[
                              Text(
                                parsed.cleanMessage,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            // Extra note/subtext
                            if (parsed.extraNote != null && parsed.extraNote!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                parsed.extraNote!,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isHighlight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyM.copyWith(
              color: isHighlight ? AppColors.error : AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
