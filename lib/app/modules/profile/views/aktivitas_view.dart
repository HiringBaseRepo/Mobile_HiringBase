import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/profile/controllers/profile_controller.dart';

class AktivitasView extends GetView<ProfileController> {
  const AktivitasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Aktivitas Saya', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      ),
      body: Obx(() => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          Text(
            'Riwayat aktivitas HR Anda di sistem',
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ...controller.activities.map((activity) {
            IconData icon;
            Color color;

            switch (activity['type']) {
              case 'login':
                icon = Icons.login_outlined;
                color = Colors.blue;
                break;
              case 'job':
                icon = Icons.work_outline;
                color = Colors.orange;
                break;
              case 'candidate':
                icon = Icons.person_search_outlined;
                color = Colors.green;
                break;
              case 'email':
                icon = Icons.email_outlined;
                color = Colors.purple;
                break;
              default:
                icon = Icons.notifications_none_outlined;
                color = AppColors.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] ?? '',
                            style: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['subtitle'] ?? '',
                            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text(
                                activity['time'] ?? '',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 40), // Bottom padding for comfortable scrolling
        ],
      )),
    );
  }
}
