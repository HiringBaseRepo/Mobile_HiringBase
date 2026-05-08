import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/jobs_controller.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.currentStep.value) {
          case 1: return _buildStepOne(context);
          case 2: return _buildStepTwo(context);
          case 3: return _buildStepThree(context);
          case 4: return _buildStepFour(context);
          case 5: return _buildSuccessStep(context);
          default: return _buildStepOne(context);
        }
      }),
      bottomNavigationBar: Obx(() => controller.currentStep.value == 5 
          ? const SizedBox.shrink() 
          : _buildBottomNavBar()),
    );
  }

  // STEP 1: JOB CORE
  Widget _buildStepOne(BuildContext context) {
    return _buildStepLayout(
      context,
      title: "Job Core",
      step: "Step 1 of 4",
      sub: "Enter the essential details about the position.",
      progress: 0.25,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.description_outlined, "Basic Information"),
              const SizedBox(height: 20),
              _buildLabel("JOB TITLE"),
              _buildTextField("e.g. Senior Software Engineer"),
              const SizedBox(height: 20),
              _buildLabel("DEPARTMENT"),
              Obx(() => _buildDropdown(
                ["Engineering", "Product", "Design", "Marketing"],
                value: controller.department.value,
                onChanged: (v) => controller.department.value = v!,
              )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("EMPLOYMENT TYPE"),
                        Obx(() => _buildDropdown(
                          ["Full-time", "Part-time", "Contract"],
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
                        _buildLabel("LOCATION"),
                        Obx(() => _buildDropdown(
                          ["Remote", "On-site", "Hybrid"],
                          value: controller.location.value,
                          onChanged: (v) => controller.location.value = v!,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildLabel("SALARY RANGE (OPTIONAL)"),
              Row(
                children: [
                  Expanded(child: _buildTextField("\$ Min", prefix: "\$")),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("to")),
                  Expanded(child: _buildTextField("\$ Max", prefix: "\$")),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.article_outlined, "Job Content"),
              const SizedBox(height: 20),
              _buildLabel("JOB DESCRIPTION"),
              _buildDescriptionField("Describe the role..."),
              const SizedBox(height: 20),
              _buildLabel("RESPONSIBILITIES"),
              _buildDescriptionField("List key responsibilities...", height: 100),
              const SizedBox(height: 20),
              _buildLabel("BENEFITS"),
              _buildDescriptionField("Health insurance, remote work, etc...", height: 100),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildNavigationButtons(showBack: false),
      ],
    );
  }

  // STEP 2: REQUIREMENT BUILDER
  Widget _buildStepTwo(BuildContext context) {
    return _buildStepLayout(
      context,
      title: "Requirement Builder",
      step: "Step 2 of 4",
      sub: "Define what skills and qualifications you are looking for.",
      progress: 0.5,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.psychology_outlined, "Skills & Qualifications", iconColor: AppColors.secondary),
              const SizedBox(height: 20),
              _buildLabel("REQUIRED SKILLS"),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.requiredSkills.map((s) => _buildChip(s, true)).toList(),
              )),
              const SizedBox(height: 10),
              _buildTextField("Add a required skill..."),
              const SizedBox(height: 25),
              _buildLabel("PREFERRED SKILLS"),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.preferredSkills.map((s) => _buildChip(s, false)).toList(),
              )),
              const SizedBox(height: 10),
              _buildTextField("Add a preferred skill..."),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.school_outlined, "Experience & Education"),
              const SizedBox(height: 20),
              _buildLabel("MINIMUM EXPERIENCE"),
              Obx(() => _buildDropdown(
                ["Entry Level", "1-2 Years", "3-5 Years", "5+ Years"],
                value: controller.minExperience.value,
                onChanged: (v) => controller.minExperience.value = v!,
              )),
              const SizedBox(height: 20),
              _buildLabel("EDUCATION MINIMUM"),
              Obx(() => _buildDropdown(
                ["High School", "Associate", "Bachelor's", "Master's", "PhD"],
                value: controller.educationMin.value,
                onChanged: (v) => controller.educationMin.value = v!,
              )),
              const SizedBox(height: 20),
              _buildLabel("CERTIFICATIONS"),
              _buildTextField("e.g. AWS Certified Developer"),
              const SizedBox(height: 20),
              _buildLabel("LANGUAGES"),
              _buildTextField("e.g. English, Indonesian"),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildNavigationButtons(),
      ],
    );
  }

  // STEP 3: APPLICANT FORM SETUP
  Widget _buildStepThree(BuildContext context) {
    return _buildStepLayout(
      context,
      title: "Applicant Form Setup",
      step: "Step 3 of 4",
      sub: "Customize the fields that applicants need to fill out.",
      progress: 0.75,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardTitle(Icons.dynamic_form_outlined, "Custom Fields"),
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
                children: controller.customFields.asMap().entries.map((e) => _buildFormFieldItem(e.key, e.value)).toList(),
              )),
            ],
          ),
        ),

        const SizedBox(height: 30),
        _buildNavigationButtons(),
      ],
    );
  }

  // STEP 4: PUBLISH CONTROL
  Widget _buildStepFour(BuildContext context) {
    return _buildStepLayout(
      context,
      title: "Publish Control",
      step: "Step 4 of 4",
      sub: "Finalize your vacancy and decide how to publish it.",
      progress: 1.0,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.send_outlined, "Visibility & Status"),
              const SizedBox(height: 20),
              _buildLabel("PUBLISH STATUS"),
              Obx(() => _buildDropdown(
                ["Public (Live)", "Private (Link Only)", "Internal Only"],
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
                    activeColor: AppColors.primary,
                  )),
                ],
              ),
              if (controller.isScheduled.value) ...[
                const SizedBox(height: 15),
                _buildTextField("Select Date & Time"),
              ],
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardTitle(Icons.qr_code_outlined, "Application Controls"),
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
                    activeColor: AppColors.primary,
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
        _buildNavigationButtons(nextText: "Publish Vacancy"),
      ],
    );
  }

  // SUCCESS STEP
  Widget _buildSuccessStep(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSuccessIcon(),
              const SizedBox(height: 30),
              Text(
                "Vacancy Published Successfully!",
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 15),
              Text(
                "Your job listing is now live and ready to receive applications. You can share the link below with potential candidates.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),
              _buildSuccessCard(title: "PUBLIC APPLICATION LINK", value: "recruit.ai/j/sr-dev-2026", icon: Icons.copy),
              const SizedBox(height: 20),
              _buildSuccessCard(title: "PRIVATE ACCESS CODE", value: "JOB-2026-X821", icon: Icons.lock_outline),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text("View Listing", style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.surface),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text("Back to Dashboard", style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UTILITY WIDGETS
  Widget _buildStepLayout(BuildContext context, {required String title, required String step, required String sub, required double progress, required List<Widget> children}) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, title, step, sub),
            const SizedBox(height: 10),
            _buildProgressBar(progress),
            const SizedBox(height: 25),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, String step, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(sub, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Text(step, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3))),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildCardTitle(IconData icon, String title, {Color iconColor = const Color(0xFF2563EB)}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.subHeader1),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildTextField(String hint, {String? prefix}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.surface)),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
          prefixText: prefix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, {required String value, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items[0],
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textTertiary),
          items: items.map((String v) => DropdownMenuItem(value: v, child: Text(v, style: AppTextStyles.bodyM))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDescriptionField(String hint, {double height = 150}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.format_bold, size: 18)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.format_list_bulleted, size: 18)),
            ],
          ),
        ),
        Container(
          height: height,
          decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)), border: Border.all(color: AppColors.surface)),
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(hintText: hint, hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary), border: InputBorder.none, contentPadding: const EdgeInsets.all(12)),
          ),
        ),
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

  Widget _buildFormFieldItem(int index, Map<String, dynamic> field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(field['name'].toString(), style: AppTextStyles.subHeader2)),
          if (field['locked'] == true) 
            const Icon(Icons.lock_outline, color: AppColors.textTertiary, size: 18)
          else ...[
            Switch(value: field['required'] as bool, onChanged: (_) => controller.toggleFieldRequired(index), activeColor: AppColors.primary),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              onPressed: () => controller.removeCustomField(index),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons({bool showBack = true, String nextText = "Continue"}) {
    return Row(
      children: [
        if (showBack)
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.previousStep(),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.textPrimary, side: BorderSide(color: AppColors.surface), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text("Previous"),
            ),
          ),
        if (showBack) const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () => controller.nextStep(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.cardBackground, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 15)),
            child: Text(nextText, style: AppTextStyles.button),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(Icons.check_circle, color: AppColors.success, size: 60),
    );
  }

  Widget _buildSuccessCard({required String title, required String value, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary)),
                const SizedBox(width: 15),
                Icon(icon, size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Get.offAllNamed('/home');
        } else if (index == 2) {
          Get.toNamed('/analytics');
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Analytic'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
