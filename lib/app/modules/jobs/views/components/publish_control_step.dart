import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/jobs_controller.dart';
import 'job_step_layout.dart';
import 'job_shared_widgets.dart';
import 'job_navigation_buttons.dart';

class PublishControlStep extends StatelessWidget {
  const PublishControlStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobsController>();

    return JobStepLayout(
      title: "Publish Control",
      step: "Step 4 of 4",
      sub: "Finalize your vacancy and decide how to publish it.",
      progress: 1.0,
      children: [
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.psychology_outlined, title: "Scoring Template (Weights)"),
              const SizedBox(height: 10),
              Text(
                "Adjust the importance of each category. Total must be 100%.",
                style: AppTextStyles.bodyS,
              ),
              const SizedBox(height: 20),
              JobWeightSlider(label: "Skill Match", weight: controller.skillMatchWeight, onChanged: (v) => controller.updateWeight(controller.skillMatchWeight, v)),
              JobWeightSlider(label: "Experience", weight: controller.experienceWeight, onChanged: (v) => controller.updateWeight(controller.experienceWeight, v)),
              JobWeightSlider(label: "Education", weight: controller.educationWeight, onChanged: (v) => controller.updateWeight(controller.educationWeight, v)),
              JobWeightSlider(label: "Portfolio", weight: controller.portfolioWeight, onChanged: (v) => controller.updateWeight(controller.portfolioWeight, v)),
              JobWeightSlider(label: "Soft Skills", weight: controller.softSkillWeight, onChanged: (v) => controller.updateWeight(controller.softSkillWeight, v)),
              JobWeightSlider(label: "Administrative", weight: controller.administrativeWeight, onChanged: (v) => controller.updateWeight(controller.administrativeWeight, v)),
              const SizedBox(height: 20),
              const Divider(height: 1, color: AppColors.surface),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TOTAL WEIGHT", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                  Obx(() {
                    final total = controller.totalWeight;
                    final isCorrect = total == 100.0;
                    return Text(
                      "${total.toInt()}%",
                      style: AppTextStyles.subHeader1.copyWith(
                        color: isCorrect ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.send_outlined, title: "Visibility & Status"),
              const SizedBox(height: 20),
              const JobLabel(label: "PUBLISH STATUS"),
              Obx(() => JobDropdown(
                items: const ["Public (Live)", "Private (Link Only)", "Internal Only"],
                value: controller.publishStatus.value,
                onChanged: (v) => controller.publishStatus.value = v!,
              )),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textTertiary),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text("Schedule Publish Date", style: AppTextStyles.subHeader2),
                  ),
                  Obx(() => Switch(
                    value: controller.isScheduled.value,
                    onChanged: (v) => controller.isScheduled.value = v,
                    activeThumbColor: AppColors.primary,
                  )),
                ],
              ),
              Obx(() => controller.isScheduled.value 
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      const JobTextField(hint: "Select Date & Time"),
                    ],
                  )
                : const SizedBox.shrink()
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.qr_code_outlined, title: "Application Controls"),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.key_outlined, size: 20, color: AppColors.textTertiary),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text("Generate Apply Code", style: AppTextStyles.subHeader2),
                  ),
                  Obx(() => Switch(
                    value: controller.generateApplyCode.value,
                    onChanged: (v) => controller.generateApplyCode.value = v,
                    activeThumbColor: AppColors.primary,
                  )),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Enabling this will create a unique code that applicants must enter to submit their application.",
                style: AppTextStyles.bodyS,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const JobNavigationButtons(nextText: "Publish Vacancy"),
      ],
    );
  }
}
