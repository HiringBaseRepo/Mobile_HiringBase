import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/home_controller.dart';

class HrStatsRow extends StatelessWidget {
  const HrStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.stats.map((stat) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  stat['icon'] as IconData,
                  color: Color(stat['color'] as int),
                  size: 28,
                ),
                const SizedBox(height: 15),
                Text(
                  stat['title'].toString(),
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'].toString(),
                  style: AppTextStyles.h2,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
