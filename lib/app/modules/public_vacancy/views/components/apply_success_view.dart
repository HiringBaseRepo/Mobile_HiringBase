import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../controllers/public_vacancy_controller.dart';

class ApplySuccessView extends GetView<PublicVacancyController> {
  const ApplySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildSuccessIcon(),
                      const SizedBox(height: 24),
                      _buildHeadlines(),
                      const SizedBox(height: 32),
                      _buildTicketCard(),
                      const SizedBox(height: 32),
                      _buildInstructionGrid(),
                      const SizedBox(height: 40),
                      _buildActionButtons(),
                      const SizedBox(height: 40),
                      _buildFooterText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.surface, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "HiringBase",
              style: AppTextStyles.h1.copyWith(
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://lh3.googleusercontent.com/a/default-user=s80-p",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
        size: 48,
      ),
    );
  }

  Widget _buildHeadlines() {
    return Column(
      children: [
        Text(
          "Application Submitted Successfully!",
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 16),
        Text(
          "Your profile has been sent to the hiring team. You can now track your progress using your unique ticket code.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "YOUR APPLICATION TICKET",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surface, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        controller.generatedTicket.value,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                          fontSize: 24,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: controller.generatedTicket.value),
                      );
                      Get.snackbar(
                        "Copied",
                        "Ticket code copied to clipboard",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary,
                        colorText: AppColors.white,
                      );
                    },
                    icon: const Icon(Icons.content_copy_rounded, size: 20),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    hoverColor: AppColors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                Icons.info_rounded,
                "Save your code",
                "Keep this ticket code to verify your identity when checking status.",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBentoCard(
                Icons.track_changes_rounded,
                "AI Screening",
                "HiringBase AI is now analyzing your resume for the best match.",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surface, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.currentStep.value = 5,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.3),
            ),
            child: Text(
              "Track Status Now",
              style: AppTextStyles.button.copyWith(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => controller.selectedVacancy.value = null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              side: const BorderSide(color: AppColors.surface, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Back to Jobs",
              style: AppTextStyles.button.copyWith(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterText() {
    return Text(
      "A confirmation email has been sent to ${controller.emailController.text}",
      textAlign: TextAlign.center,
      style: AppTextStyles.bodyS.copyWith(color: AppColors.textTertiary),
    );
  }
}
