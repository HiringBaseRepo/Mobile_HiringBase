import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = Get.find<AppService>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment_ind,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'SmartScreen AI',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        Row(
          children: [
            Stack(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Obx(() {
              final user = appService.currentUser.value;
              final hasImg = user?.imageUrl != null && user!.imageUrl!.isNotEmpty;
              final name = user?.name ?? '';
              final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

              return GestureDetector(
                onTap: () {
                  try {
                    Get.find<NavigationService>().changeTo(3);
                  } catch (_) {
                    Get.toNamed(Routes.PROFILE);
                  }
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: hasImg ? NetworkImage(user.imageUrl!) : null,
                  child: !hasImg
                      ? Text(
                          initial,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
