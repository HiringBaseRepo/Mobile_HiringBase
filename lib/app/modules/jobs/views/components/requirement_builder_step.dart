import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
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
        // ── Skills card ────────────────────────────────────────────────
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(
                icon: Icons.psychology_outlined,
                title: "Skills & Qualifications",
                iconColor: AppColors.secondary,
              ),
              const SizedBox(height: 20),

              // Required Skills
              const JobLabel(label: "REQUIRED SKILLS"),
              Obx(() => controller.requiredSkills.isEmpty
                  ? _emptyHint("No required skills added yet.")
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.requiredSkills
                          .map((s) => _SkillChip(
                                label: s,
                                isRequired: true,
                                onRemove: () => controller.removeSkill(s, true),
                              ))
                          .toList(),
                    )),
              const SizedBox(height: 10),
              // Add required skill input
              JobTextField(
                hint: "Type required skill & press Enter…",
                controller: controller.requiredSkillController,
                onSubmitted: (val) {
                  controller.addSkill(val.trim(), true);
                  controller.requiredSkillController.clear();
                },
              ),
              const SizedBox(height: 25),

              // Preferred Skills
              const JobLabel(label: "PREFERRED SKILLS"),
              Obx(() => controller.preferredSkills.isEmpty
                  ? _emptyHint("No preferred skills added yet.")
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.preferredSkills
                          .map((s) => _SkillChip(
                                label: s,
                                isRequired: false,
                                onRemove: () => controller.removeSkill(s, false),
                              ))
                          .toList(),
                    )),
              const SizedBox(height: 10),
              // Add preferred skill input
              JobTextField(
                hint: "Type preferred skill & press Enter…",
                controller: controller.preferredSkillController,
                onSubmitted: (val) {
                  controller.addSkill(val.trim(), false);
                  controller.preferredSkillController.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // ── Experience & Education card ────────────────────────────────
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(
                icon: Icons.school_outlined,
                title: "Experience & Education",
              ),
              const SizedBox(height: 20),
              const JobLabel(label: "MINIMUM EXPERIENCE"),
              Obx(() => JobDropdown(
                    items: const [
                      "Entry Level",
                      "1-2 Years",
                      "3-5 Years",
                      "5+ Years",
                    ],
                    value: controller.minExperience.value,
                    onChanged: (v) => controller.minExperience.value = v!,
                  )),
              const SizedBox(height: 20),
              const JobLabel(label: "EDUCATION MINIMUM"),
              Obx(() => JobDropdown(
                    items: const [
                      "High School",
                      "Associate",
                      "Bachelor's",
                      "Master's",
                      "PhD",
                    ],
                    value: controller.educationMin.value,
                    onChanged: (v) => controller.educationMin.value = v!,
                  )),

            ],
          ),
        ),
        const SizedBox(height: 30),
        const JobNavigationButtons(),
      ],
    );
  }

  Widget _emptyHint(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
      );
}

/// Tappable chip with a remove (×) button.
class _SkillChip extends StatelessWidget {
  final String label;
  final bool isRequired;
  final VoidCallback onRemove;

  const _SkillChip({
    required this.label,
    required this.isRequired,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isRequired
        ? AppColors.primary.withValues(alpha: 0.12)
        : AppColors.surface;
    final fg = isRequired ? AppColors.primary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: fg),
          ),
        ],
      ),
    );
  }
}
