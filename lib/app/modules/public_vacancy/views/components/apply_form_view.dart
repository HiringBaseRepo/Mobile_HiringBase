import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../controllers/public_vacancy_controller.dart';

class ApplyFormView extends GetView<PublicVacancyController> {
  const ApplyFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => controller.currentStep.value--,
        ),
        title: Obx(() => Text(
          controller.currentStep.value == 2 ? "Data Diri" : "Unggah Berkas",
          style: AppTextStyles.subHeader1,
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.currentStep.value == 2) {
          return _buildPersonalInfoForm();
        } else {
          return _buildDocumentUpload();
        }
      }),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildPersonalInfoForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi Kontak", style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            "Isi informasi diri Anda dengan benar untuk memudahkan proses screening.",
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildFieldGroup("Nama Lengkap", controller.fullNameController, "Contoh: John Doe"),
          const SizedBox(height: 20),
          _buildFieldGroup("Email Aktif", controller.emailController, "Contoh: john@example.com", keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),
          _buildFieldGroup("Nomor WhatsApp", controller.phoneController, "Contoh: 08123456789", keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          _buildFieldGroup("LinkedIn URL (Opsional)", controller.linkedinController, "linkedin.com/in/username"),
          const SizedBox(height: 32),
          _buildProfessionalExperienceCard(),
        ],
      ),
    );
  }

  Widget _buildProfessionalExperienceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Professional Experience", style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Text(
            "WORK EXPERIENCE",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surface),
            ),
            child: TextField(
              controller: controller.experienceController,
              maxLines: 4,
              style: AppTextStyles.bodyM,
              decoration: InputDecoration(
                hintText: "Briefly describe your relevant roles and responsibilities...",
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "SKILLS & TECHNOLOGIES",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.skills.map((skill) => _buildSkillChip(skill)).toList(),
              )),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surface),
            ),
            child: TextField(
              controller: controller.skillInputController,
              onSubmitted: (value) => controller.addSkill(value),
              style: AppTextStyles.bodyM,
              decoration: InputDecoration(
                hintText: "Type a skill and press enter...",
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => controller.removeSkill(label),
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUpload() {
    final docs = controller.uploadedDocs.keys.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Unggah Dokumen", style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                "Pastikan format file sesuai (PDF/JPG/PNG) dan ukuran maksimal 5MB.",
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final docName = docs[index];
              return Obx(() {
                final isUploaded = controller.uploadedDocs[docName] ?? false;
                return _buildUploadCard(docName, isUploaded);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFieldGroup(String label, TextEditingController textController, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surface, width: 2),
          ),
          child: TextField(
            controller: textController,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyM,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard(String label, bool isUploaded) {
    final fileName = controller.selectedFiles[label]?.name;
    return GestureDetector(
      onTap: () => isUploaded ? null : controller.pickDocument(label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded ? AppColors.success.withValues(alpha: 0.05) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUploaded ? AppColors.success : AppColors.surface, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isUploaded ? AppColors.success : AppColors.textTertiary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUploaded ? Icons.description_outlined : Icons.cloud_upload_outlined,
                color: isUploaded ? AppColors.success : AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    isUploaded ? (fileName ?? "Berhasil diunggah") : "Ketuk untuk memilih file (PDF, JPG, PNG)",
                    style: AppTextStyles.caption.copyWith(
                      color: isUploaded ? AppColors.success : AppColors.textTertiary,
                      fontWeight: isUploaded ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUploaded)
              GestureDetector(
                onTap: () => controller.removeDocument(label),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.delete_outline_rounded, color: AppColors.error.withValues(alpha: 0.8), size: 22),
                ),
              )
            else
              const Icon(Icons.add_rounded, color: AppColors.textTertiary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentStep.value == 2) {
                  controller.nextStep();
                } else {
                  controller.submitApplication();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Obx(() => Text(
                controller.currentStep.value == 2 ? "Lanjut ke Berkas" : "Kirim Lamaran",
                style: AppTextStyles.button.copyWith(fontSize: 16),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
