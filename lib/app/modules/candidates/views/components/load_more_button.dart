import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';

class LoadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const LoadMoreButton({
    super.key,
    required this.onPressed,
    this.label = 'Load More Candidates',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.keyboard_arrow_down),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: AppColors.surface),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        ),
      ),
    );
  }
}
