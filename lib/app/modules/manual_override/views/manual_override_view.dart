import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/manual_override_controller.dart';

class ManualOverrideView extends GetView<ManualOverrideController> {
  const ManualOverrideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text('Manual Override', style: AppTextStyles.subHeader1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CandidateSummary(candidate: controller.candidate.value),
            const SizedBox(height: 32),
            _SectionTitle(title: 'Set Target Scores'),
            const SizedBox(height: 12),
            _AdjustmentSlider(label: 'Skill Match', value: controller.skillVal),
            _AdjustmentSlider(label: 'Experience', value: controller.expVal),
            _AdjustmentSlider(label: 'Education', value: controller.eduVal),
            _AdjustmentSlider(label: 'Portfolio', value: controller.portVal),
            _AdjustmentSlider(label: 'Soft Skill', value: controller.softVal),
            _AdjustmentSlider(label: 'Administrative', value: controller.adminVal),
            
            const SizedBox(height: 32),
            _ScorePreviewCard(),
            
            const SizedBox(height: 32),
            _SectionTitle(title: 'Reason for Override (Mandatory)'),
            const SizedBox(height: 12),
            TextField(
              controller: controller.reasonController,
              maxLines: 3,
              decoration: _inputDecoration('Explain why you are overriding this data...'),
            ),
            const SizedBox(height: 40),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitOverride,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                  : Text('Save Changes', style: AppTextStyles.button),
              ),
            )),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surface),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surface),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}

class _AdjustmentSlider extends StatelessWidget {
  final String label;
  final RxDouble value;

  const _AdjustmentSlider({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500)),
            Obx(() => Text(
              value.value.toStringAsFixed(0),
              style: AppTextStyles.bodyM.copyWith(
                fontWeight: FontWeight.bold,
                color: value.value > 70 ? AppColors.success : (value.value < 40 ? AppColors.error : AppColors.textSecondary),
              ),
            )),
          ],
        ),
        Obx(() => SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value.value,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surface,
            onChanged: (val) => value.value = val,
          ),
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ScorePreviewCard extends GetView<ManualOverrideController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PREVIEW SCORE', style: AppTextStyles.caption.copyWith(color: AppColors.white70, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Final recalculation result', style: AppTextStyles.caption.copyWith(color: AppColors.white60, fontSize: 10)),
            ],
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              controller.previewScore.toStringAsFixed(1),
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          )),
        ],
      ),
    );
  }
}

class _CandidateSummary extends StatelessWidget {
  final dynamic candidate;
  const _CandidateSummary({required this.candidate});

  @override
  Widget build(BuildContext context) {
    if (candidate == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(candidate.imageUrl)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(candidate.name, style: AppTextStyles.subHeader2),
              Text(candidate.role, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.subHeader2.copyWith(fontSize: 14));
  }
}
