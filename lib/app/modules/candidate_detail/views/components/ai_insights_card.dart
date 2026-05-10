import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class AiInsightsCard extends StatelessWidget {
  final int score;
  final String reasoning;
  final bool isManualOverride;

  const AiInsightsCard({
    super.key,
    required this.score,
    required this.reasoning,
    this.isManualOverride = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI INSIGHTS',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Match Score',
                        style: AppTextStyles.bodyS,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$score',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '/100',
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (isManualOverride) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flash_on, size: 12, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                'Override Aktif',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.amber[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 8,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: score / 100,
                              strokeWidth: 8,
                              color: AppColors.primary,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildProgressItem('Skill Match', 0.98, '98%'),
              const SizedBox(height: 16),
              _buildProgressItem('Experience', 0.85, '85%'),
              const SizedBox(height: 16),
              _buildProgressItem('Education', 0.90, '90%'),
              const SizedBox(height: 24),
              const Divider(height: 1, color: AppColors.surface),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SCORING REASONING',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"$reasoning"',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(String label, double value, String percent) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500)),
            Text(percent, style: AppTextStyles.bodyM.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.surface,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
