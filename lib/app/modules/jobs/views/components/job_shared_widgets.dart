import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class JobCard extends StatelessWidget {
  final Widget child;
  const JobCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }
}

class JobLabel extends StatelessWidget {
  final String label;
  const JobLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class JobTextField extends StatelessWidget {
  final String hint;
  final String? prefix;
  final bool isDescription;
  final double? height;

  const JobTextField({
    super.key,
    required this.hint,
    this.prefix,
    this.isDescription = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (isDescription) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.format_bold, size: 18)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.format_list_bulleted, size: 18)),
              ],
            ),
          ),
          Container(
            height: height ?? 150,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border.all(color: AppColors.surface),
            ),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surface),
      ),
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
}

class JobDropdown extends StatelessWidget {
  final List<String> items;
  final String value;
  final Function(String?) onChanged;

  const JobDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surface),
      ),
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
}

class JobCardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const JobCardTitle({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.subHeader1),
      ],
    );
  }
}

class JobWeightSlider extends StatelessWidget {
  final String label;
  final RxDouble weight;
  final Function(double) onChanged;

  const JobWeightSlider({
    super.key,
    required this.label,
    required this.weight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500)),
            Obx(() => Text("${weight.value.toInt()}%", 
              style: AppTextStyles.bodyM.copyWith(
                fontWeight: FontWeight.bold, 
                color: AppColors.primary
              )
            )),
          ],
        ),
        Obx(() => SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: weight.value,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surface,
            onChanged: onChanged,
          ),
        )),
      ],
    );
  }
}
