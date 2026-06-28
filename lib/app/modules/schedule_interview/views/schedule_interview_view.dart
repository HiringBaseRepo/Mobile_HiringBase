import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/schedule_interview_controller.dart';

class ScheduleInterviewView extends GetView<ScheduleInterviewController> {
  const ScheduleInterviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text('Schedule Interview', style: AppTextStyles.subHeader1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CandidateHeader(candidate: controller.candidate.value),
            const SizedBox(height: 32),
            _Label('Select Date'),
            const SizedBox(height: 8),
            TextField(
              controller: controller.dateController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null && context.mounted) {
                  controller.dateController.text = "${date.year}-${date.month}-${date.day}";
                }
              },
              decoration: _inputDecoration(Icons.calendar_today_outlined, 'YYYY-MM-DD'),
            ),
            const SizedBox(height: 24),
            _Label('Select Time'),
            const SizedBox(height: 8),
            TextField(
              controller: controller.timeController,
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                );
                if (time != null && context.mounted) {
                  controller.timeController.text = time.format(context);
                }
              },
              decoration: _inputDecoration(Icons.access_time_outlined, 'HH:MM'),
            ),
            const SizedBox(height: 24),
            _Label('Interview Platform'),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 12,
              children: ['Google Meet', 'Zoom', 'WhatsApp', 'In-Person'].map((p) {
                final isSelected = controller.selectedPlatform.value == p;
                return GestureDetector(
                  onTap: () {
                    controller.selectedPlatform.value = p;
                    controller.linkController.clear();
                    controller.locationController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      p,
                      style: AppTextStyles.bodyM.copyWith(
                        color: isSelected ? AppColors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 24),
            Obx(() {
              final platform = controller.selectedPlatform.value;
              if (platform == 'In-Person') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Location'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.locationController,
                      decoration: _inputDecoration(Icons.location_on_outlined, 'e.g. Kantor Utama Jl. Sudirman'),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(platform == 'WhatsApp' ? 'WhatsApp Link (optional)' : 'Meeting Link'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.linkController,
                    decoration: _inputDecoration(Icons.link, 'e.g. https://meet.google.com/abc-defg-hij'),
                  ),
                ],
              );
            }),
            const SizedBox(height: 48),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                  : Text('Send Invitation', style: AppTextStyles.button),
              ),
            )),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 20),
      filled: true,
      fillColor: AppColors.surface.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.subHeader2.copyWith(fontSize: 14));
  }
}

class _CandidateHeader extends StatelessWidget {
  final dynamic candidate;
  const _CandidateHeader({required this.candidate});

  @override
  Widget build(BuildContext context) {
    if (candidate == null) return const SizedBox();
    final hasImg = candidate.imageUrl != null && candidate.imageUrl.isNotEmpty;
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: hasImg
              ? ClipOval(
                  child: Image.network(
                    candidate.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        candidate.name != null && candidate.name.isNotEmpty
                            ? candidate.name[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
                      );
                    },
                  ),
                )
              : Text(
                  candidate.name != null && candidate.name.isNotEmpty
                      ? candidate.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                candidate.name ?? 'Unknown',
                style: AppTextStyles.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Scheduled for ${candidate.role ?? 'Unknown Role'}',
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
