import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/navigation_service.dart';
import '../../services/app_service.dart';
import '../values/app_colors.dart';
import '../values/app_text_styles.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navService = Get.find<NavigationService>();
    final appService = Get.find<AppService>();

    return Obx(
      () {
        final items = appService.isHR ? _hrItems : _applicantItems;
        final currentIndex = navService.selectedIndex.value;
        // Clamp index to prevent assertion error during role transition
        final safeIndex = currentIndex < items.length ? currentIndex : 0;

        return BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) {
            navService.changeTo(index);
          },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
        items: items,
      );
    });
  }

  static const List<BottomNavigationBarItem> _hrItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.work_outline),
      label: 'Jobs',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Profile',
    ),
  ];

  static const List<BottomNavigationBarItem> _applicantItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.work_outline),
      label: 'Lowongan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.track_changes_outlined),
      label: 'Lacak',
    ),
  ];
}
