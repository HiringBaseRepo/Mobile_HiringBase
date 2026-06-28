import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/profile/controllers/profile_controller.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Color(0xFFB71C1C)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      child: Obx(() => Column(
            children: [
              // Avatar circle
              Stack(
                children: [
                  GestureDetector(
                    onTap: controller.changeAvatar,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4),
                        color: AppColors.white.withValues(alpha: 0.2),
                      ),
                      child: controller.userAvatar != null && controller.userAvatar!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                controller.userAvatar!,
                                fit: BoxFit.cover,
                                width: 102,
                                height: 102,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      controller.initials,
                                      style: AppTextStyles.h1
                                          .copyWith(color: AppColors.white, fontSize: 36),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text(
                                controller.initials,
                                style: AppTextStyles.h1
                                    .copyWith(color: AppColors.white, fontSize: 36),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.changeAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                controller.userName,
                style: AppTextStyles.h1.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                controller.userEmail,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 14, color: AppColors.white),
                    const SizedBox(width: 6),
                    Text(
                      controller.userRole,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
