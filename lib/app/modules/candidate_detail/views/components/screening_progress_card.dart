import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/views/components/warning_card.dart';

/// Displays the AI screening lifecycle to HR:
/// - In-progress: pulsing animation + step indicator
/// - Failure: red card with reason (doc_failed, knockout)
class ScreeningProgressCard extends StatelessWidget {
  final String status;
  final String? rejectionReason;

  const ScreeningProgressCard({
    super.key,
    required this.status,
    this.rejectionReason,
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
              const Icon(Icons.psychology, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI SCREENING',
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
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (status) {
      case 'doc_check':
        return _buildInProgressStep(
          icon: Icons.folder_open,
          title: 'Validating Documents',
          subtitle: 'Checking uploaded documents against requirements...',
          step: 1,
          totalSteps: 2,
        );
      case 'ai_processing':
        return _buildInProgressStep(
          icon: Icons.auto_awesome,
          title: 'AI Analysis in Progress',
          subtitle: 'Scanning documents, matching skills, and generating score...',
          step: 2,
          totalSteps: 2,
        );
      case 'applied':
        return _buildQueuedState();
      case 'doc_failed':
        return _buildFailureState(
          icon: Icons.folder_off,
          title: 'Document Check Failed',
          subtitle: rejectionReason ?? 'One or more required documents are missing or invalid.',
        );
      case 'knockout':
        return _buildFailureState(
          icon: Icons.gpp_bad,
          title: 'Knockout Rule Failed',
          subtitle: rejectionReason ?? 'Candidate does not meet one or more mandatory requirements.',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInProgressStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required int step,
    required int totalSteps,
  }) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  Icon(icon, color: AppColors.primary, size: 24),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subHeader1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildStepProgress(step, totalSteps),
      ],
    );
  }

  Widget _buildQueuedState() {
    return Row(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 4,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              const Icon(Icons.hourglass_top, color: AppColors.primary, size: 24),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Screening Queued',
                style: AppTextStyles.subHeader1.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Application submitted. Screening will start shortly...',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFailureState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subHeader1.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...subtitle
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => WarningCard(rawMessage: line)),
      ],
    );
  }

  Widget _buildStepProgress(int currentStep, int totalSteps) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (i) {
            final isActive = i < currentStep;
            return Expanded(
              child: Container(
                height: 6,
                margin: i < totalSteps - 1 ? const EdgeInsets.only(right: 6) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Document Check',
              style: AppTextStyles.caption.copyWith(
                color: currentStep > 1 ? AppColors.primary : AppColors.textSecondary,
                fontWeight: currentStep > 1 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Text(
              'AI Scoring',
              style: AppTextStyles.caption.copyWith(
                color: currentStep > 2 ? AppColors.primary : AppColors.textSecondary,
                fontWeight: currentStep > 2 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
