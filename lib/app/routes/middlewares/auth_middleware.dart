import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/app_service.dart';
import '../app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final appService = Get.find<AppService>();
    
    // If no role is selected, redirect to selection page
    if (appService.currentRole.value.isEmpty) {
      return const RouteSettings(name: Routes.SELECTION);
    }

    // Role-based route protection
    final isApplicant = appService.isApplicant;
    final hrOnlyRoutes = [
      Routes.HOME,
      Routes.CANDIDATES,
      Routes.JOBS_LIST,
      Routes.ANALYTICS,
      Routes.PROFILE,
      Routes.SETTINGS,
    ];

    if (isApplicant && hrOnlyRoutes.contains(route)) {
      return const RouteSettings(name: Routes.PUBLIC_VACANCY);
    }
    
    return null;
  }
}
