import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/profile/controllers/profile_controller.dart';
import 'profile_info_card.dart';

class ProfileChangePasswordSection extends GetView<ProfileController> {
  const ProfileChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.otpSent.value) {
        return Column(
          children: [
            const ProfileInfoTile(
              icon: Icons.lock_outlined,
              label: 'Password',
              value: '••••••••',
            ),
            const ProfileInfoTile(
              icon: Icons.shield_outlined,
              label: 'Account Status',
              value: 'Active & Verified',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isSendingOtp.value
                    ? null
                    : () => controller.sendOtp(),
                icon: controller.isSendingOtp.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.key_outlined, color: AppColors.white),
                label: Text(controller.isSendingOtp.value
                    ? 'Mengirim OTP...'
                    : 'Ubah Kata Sandi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        );
      }

      // Jika OTP sudah dikirim, tampilkan form
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kode OTP 6-digit telah dikirimkan ke email Anda. Silakan periksa inbox atau spam.',
                    style: AppTextStyles.bodyS.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Kode OTP', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Masukkan 6 digit OTP',
              counterText: '',
              prefixIcon: const Icon(Icons.pin_outlined),
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Kata Sandi Baru', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Minimal 8 karakter',
              prefixIcon: const Icon(Icons.lock_outline),
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Konfirmasi Kata Sandi Baru', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Ulangi kata sandi baru',
              prefixIcon: const Icon(Icons.lock_outline),
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isResettingPassword.value
                  ? null
                  : () => controller.submitPasswordReset(),
              icon: controller.isResettingPassword.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline, color: AppColors.white),
              label: Text(controller.isResettingPassword.value
                  ? 'Menyimpan...'
                  : 'Simpan Kata Sandi Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                controller.otpSent.value = false;
                controller.otpController.clear();
                controller.newPasswordController.clear();
                controller.confirmPasswordController.clear();
              },
              child: Text(
                'Batal',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
