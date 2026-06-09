import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';

class HrGreeting extends StatelessWidget {
  const HrGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = Get.find<AppService>();

    return Obx(() {
      final name = appService.currentUser.value?.name ?? 'HR Partner';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning, $name',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 4),
          Text(
            'Here is your daily recruitment overview.',
            style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary),
          ),
        ],
      );
    });
  }
}
