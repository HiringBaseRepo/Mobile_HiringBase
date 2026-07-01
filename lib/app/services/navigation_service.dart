import 'package:get/get.dart';
import '../routes/app_pages.dart';
import 'app_service.dart';

class NavigationService extends GetxService {
  final selectedIndex = 0.obs;

  static final _hrRoutes = [
    Routes.HOME,
    Routes.JOBS_LIST,
    Routes.PROFILE,
  ];

  static final _applicantRoutes = [
    Routes.PUBLIC_VACANCY,
    Routes.TRACK_STATUS,
  ];

  void changeTo(int index) {
    if (selectedIndex.value == index) return;
    
    final appService = Get.find<AppService>();
    final routes = appService.isHR ? _hrRoutes : _applicantRoutes;

    if (index >= 0 && index < routes.length) {
      selectedIndex.value = index;
      Get.offAllNamed(routes[index]);
    }
  }

  void reset() {
    selectedIndex.value = 0;
  }
}
