import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/jobs_controller.dart';
import 'job_step_layout.dart';
import 'job_shared_widgets.dart';
import 'job_navigation_buttons.dart';

class ApplicantFormSetupStep extends StatelessWidget {
  const ApplicantFormSetupStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobsController>();

    return JobStepLayout(
      title: "Applicant Form Setup",
      step: "Step 3 of 4",
      sub: "Customize the fields that applicants need to fill out.",
      progress: 0.75,
      children: [
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.dynamic_form_outlined, title: "Custom Fields"),
              const SizedBox(height: 4),
              Text(
                "Add extra fields applicants must fill. Toggle required/optional.",
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Standard fields (Nama Lengkap, Email, WhatsApp, Pendidikan, Pengalaman Kerja) are already included in the applicant form automatically.",
                        style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                    onPressed: () {
                      final textController = TextEditingController();
                      Get.defaultDialog(
                        title: "Add Custom Field",
                        titleStyle: AppTextStyles.h2,
                        backgroundColor: AppColors.cardBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        content: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "e.g. Portfolio Link",
                            hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.surface)),
                          ),
                        ),
                        textConfirm: "Add",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        buttonColor: AppColors.primary,
                         onConfirm: () {
                          final label = textController.text.trim();
                          if (label.isEmpty) { Get.back(); return; }
                          final lowerLabel = label.toLowerCase();
                          const standardKeys = [
                            'education', 'work experience', 'full name',
                            'email', 'phone', 'whatsapp',
                          ];
                          if (standardKeys.contains(lowerLabel)) {
                            Get.back();
                            Get.snackbar('Info', 'This field is already a standard part of the form.');
                            return;
                          }
                          controller.formFieldsPreview.add({'label': label, 'is_required': false});
                           Get.back();
                         },
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add"),
                  ),
              ),
              const SizedBox(height: 20),
              Obx(() => Column(
                children: controller.formFieldsPreview.asMap().entries.map((e) => _buildFormFieldItem(e.key, e.value, controller)).toList(),
              )),
            ],
          ),
        ),
        const SizedBox(height: 30),
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.upload_file_outlined, title: "Required Documents"),
              const SizedBox(height: 8),
              Text(
                "Select which documents applicants must upload when applying.",
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: JobsController.documentTypes.map((doc) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  activeColor: AppColors.primary,
                  title: Text(doc['label'] ?? '', style: AppTextStyles.bodyM),
                  value: controller.selectedDocs.contains(doc['key']),
                  onChanged: (_) => controller.toggleDoc(doc['key']!),
                )).toList(),
              )),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const JobNavigationButtons(),
      ],
    );
  }

  Widget _buildFormFieldItem(int index, Map<String, dynamic> field, JobsController controller) {
    final bool isRequired = field['is_required'] as bool? ?? false;
    final String label = field['label']?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.surface.withValues(alpha: 0.5))),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.subHeader2)),
          Text(
            isRequired ? 'Required' : 'Optional',
            style: AppTextStyles.caption.copyWith(
              color: isRequired ? AppColors.primary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Switch(value: isRequired, onChanged: (_) => controller.toggleFieldRequired(index), activeThumbColor: AppColors.primary),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            onPressed: () {
              controller.formFieldsPreview.removeAt(index);
            },
          ),
        ],
      ),
    );
  }
}
