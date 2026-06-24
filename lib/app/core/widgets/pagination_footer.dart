import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class PaginationFooter extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;
  final String noMoreText;

  const PaginationFooter({
    super.key,
    required this.isLoading,
    required this.hasMore,
    this.noMoreText = 'Semua data telah dimuat',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            noMoreText,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return const SizedBox(height: 20);
  }
}
