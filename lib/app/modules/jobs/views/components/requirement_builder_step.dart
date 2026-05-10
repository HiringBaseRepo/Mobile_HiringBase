import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/jobs_controller.dart';
import 'job_step_layout.dart';
import 'job_shared_widgets.dart';
import 'job_navigation_buttons.dart';

class RequirementBuilderStep extends StatelessWidget {
  const RequirementBuilderStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobsController>();

    return JobStepLayout(
      title: "Requirement Builder",
      step: "Step 2 of 4",
      sub: "Define what skills and qualifications you are looking for.",
      progress: 0.5,
      children: [
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.psychology_outlined, title: "Skills & Qualifications", iconColor: AppColors.secondary),
              const SizedBox(height: 20),
              const JobLabel(label: "REQUIRED SKILLS"),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.requiredSkills.map((s) => _buildChip(s, true)).toList(),
              )),
              const SizedBox(height: 10),
              const JobTextField(hint: "Add a required skill..."),
              const SizedBox(height: 25),
              const JobLabel(label: "PREFERRED SKILLS"),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.preferredSkills.map((s) => _buildChip(s, false)).toList(),
              )),
              const SizedBox(height: 10),
              const JobTextField(hint: "Add a preferred skill..."),
            ],
          ),
        ),
        const SizedBox(height: 25),
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.school_outlined, title: "Experience & Education"),
              const SizedBox(height: 20),
              const JobLabel(label: "MINIMUM EXPERIENCE"),
              Obx(() => JobDropdown(
                items: const ["Entry Level", "1-2 Years", "3-5 Years", "5+ Years"],
                value: controller.minExperience.value,
                onChanged: (v) => controller.minExperience.value = v!,
              )),
              const SizedBox(height: 20),
              const JobLabel(label: "EDUCATION MINIMUM"),
              Obx(() => JobDropdown(
                items: const ["High School", "Associate", "Bachelor's", "Master's", "PhD"],
                value: controller.educationMin.value,
                onChanged: (v) => controller.educationMin.value = v!,
              )),
              const SizedBox(height: 20),
              const JobLabel(label: "CERTIFICATIONS"),
              const JobTextField(hint: "e.g. AWS Certified Developer"),
              const SizedBox(height: 20),
              const JobLabel(label: "LANGUAGES"),
              const JobTextField(hint: "e.g. English, Indonesian"),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const JobNavigationButtons(),
      ],
    );
  }

  Widget _buildChip(String label, bool isRequired) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isRequired ? AppColors.accent : AppColors.surface, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: isRequired ? AppColors.accentText : AppColors.textSecondary)),
          const SizedBox(width: 5),
          Icon(Icons.close, size: 14, color: isRequired ? AppColors.accentText : AppColors.textSecondary),
        ],
      ),
    );
  }
}
