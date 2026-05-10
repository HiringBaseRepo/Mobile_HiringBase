import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class HrGreeting extends StatelessWidget {
  final String name;
  const HrGreeting({super.key, this.name = 'Sarah'});

  @override
  Widget build(BuildContext context) {
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
  }
}
