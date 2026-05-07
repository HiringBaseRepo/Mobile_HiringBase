import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'app/core/values/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "SmartScreen AI",
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
