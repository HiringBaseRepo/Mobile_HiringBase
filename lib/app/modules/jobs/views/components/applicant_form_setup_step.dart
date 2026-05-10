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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const JobCardTitle(icon: Icons.dynamic_form_outlined, title: "Custom Fields"),
                  TextButton.icon(
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
                          controller.addCustomField(textController.text);
                          Get.back();
                        },
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() => Column(
                children: controller.customFields.asMap().entries.map((e) => _buildFormFieldItem(e.key, e.value, controller)).toList(),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.surface.withValues(alpha: 0.5))),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(field['name'].toString(), style: AppTextStyles.subHeader2)),
          if (field['locked'] == true) 
            const Icon(Icons.lock_outline, color: AppColors.textTertiary, size: 18)
          else ...[
            Switch(value: field['required'] as bool, onChanged: (_) => controller.toggleFieldRequired(index), activeThumbColor: AppColors.primary),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              onPressed: () => controller.removeCustomField(index),
            ),
          ],
        ],
      ),
    );
  }
}
