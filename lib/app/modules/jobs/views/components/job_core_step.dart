import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'job_step_layout.dart';
import 'job_shared_widgets.dart';
import 'job_navigation_buttons.dart';

class JobCoreStep extends StatelessWidget {
  const JobCoreStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobsController>();

    return JobStepLayout(
      title: "Job Core",
      step: "Step 1 of 4",
      sub: "Enter the essential details about the position.",
      progress: 0.25,
      children: [
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.description_outlined, title: "Basic Information"),
              const SizedBox(height: 20),

              // ── Job Title ──────────────────────────────────────────────
              const JobLabel(label: "JOB TITLE"),
              JobTextField(
                hint: "e.g. Senior Software Engineer",
                controller: controller.titleController,
              ),
              const SizedBox(height: 20),

              // ── Department ────────────────────────────────────────────
              const JobLabel(label: "DEPARTMENT"),
              Obx(() => JobDropdown(
                items: const ["Engineering", "Product", "Design", "Marketing", "HR", "Finance", "Operations"],
                value: controller.department.value,
                onChanged: (v) => controller.department.value = v!,
              )),
              const SizedBox(height: 20),

              // ── Employment Type & Location ────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const JobLabel(label: "EMPLOYMENT TYPE"),
                        Obx(() => JobDropdown(
                          items: const ["full_time", "part_time", "contract", "freelance", "intern"],
                          value: controller.employmentType.value,
                          onChanged: (v) => controller.employmentType.value = v!,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const JobLabel(label: "LOCATION"),
                        Obx(() => JobDropdown(
                          items: const ["Remote", "On-site", "Hybrid"],
                          value: controller.location.value,
                          onChanged: (v) => controller.location.value = v!,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Salary Range ──────────────────────────────────────────
              const JobLabel(label: "SALARY RANGE (OPTIONAL)"),
              Row(
                children: [
                  Expanded(child: JobTextField(
                    hint: "Min",
                    prefix: "Rp ",
                    controller: controller.salaryMinController,
                  )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("to"),
                  ),
                  Expanded(child: JobTextField(
                    hint: "Max",
                    prefix: "Rp ",
                    controller: controller.salaryMaxController,
                  )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // ── Job Content card ────────────────────────────────────────────
        JobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobCardTitle(icon: Icons.article_outlined, title: "Job Content"),
              const SizedBox(height: 20),
              const JobLabel(label: "JOB DESCRIPTION"),
              JobTextField(
                hint: "Describe the role...",
                isDescription: true,
                controller: controller.descriptionController,
              ),
              const SizedBox(height: 20),
              const JobLabel(label: "RESPONSIBILITIES"),
              JobTextField(
                hint: "List key responsibilities...",
                isDescription: true,
                height: 100,
                controller: controller.responsibilitiesController,
              ),
              const SizedBox(height: 20),
              const JobLabel(label: "BENEFITS"),
              JobTextField(
                hint: "Health insurance, remote work, etc...",
                isDescription: true,
                height: 100,
                controller: controller.benefitsController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const JobNavigationButtons(showBack: false),
      ],
    );
  }
}
