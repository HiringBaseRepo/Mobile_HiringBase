import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'app/core/values/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/services/app_service.dart';
import 'app/services/auth_service.dart';
import 'app/services/job_service.dart';
import 'app/services/application_service.dart';
import 'app/services/navigation_service.dart';
import 'app/services/scoring_service.dart';
import 'app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize Global Services (order matters: AppService first)
  Get.put(AppService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(JobService(), permanent: true);
  Get.put(ApplicationService(), permanent: true);
  Get.put(NavigationService(), permanent: true);
  Get.put(ScoringService(), permanent: true);
  Get.put(NotificationService(), permanent: true);

  // Restore persisted session before app starts
  await Get.find<AppService>().init();

  runApp(
    GetMaterialApp(
      title: "HiringBase",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.cardBackground,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
