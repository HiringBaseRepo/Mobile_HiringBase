import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildSettingsGroup(
                    title: 'Account Settings',
                    items: [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        label: 'Personal Info',
                        onTap: () => _showBottomSheet(
                            context, 'Personal Info', _buildPersonalInfoContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.security_outlined,
                        label: 'Security & Password',
                        onTap: () => _showBottomSheet(
                            context, 'Security & Password', _buildSecurityContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.history_outlined,
                        label: 'Aktivitas Saya',
                        onTap: () => Get.toNamed('/aktivitas'),
                      ),
                      _SettingsItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications',
                        onTap: () => _showBottomSheet(
                            context, 'Notifications', _buildNotificationContent()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsGroup(
                    title: 'System Preferences',
                    items: [
                      _SettingsItem(
                        icon: Icons.language_outlined,
                        label: 'Language',
                        onTap: () =>
                            _showBottomSheet(context, 'Language', _buildLanguageContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.help_outline,
                        label: 'Help & Support',
                        onTap: () => _showBottomSheet(
                            context, 'Help & Support', _buildHelpContent()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────
  Widget _buildPremiumHeader() {
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
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.white.withValues(alpha: 0.2),
                      image: controller.userAvatar != null
                          ? DecorationImage(
                              image: NetworkImage(controller.userAvatar!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.userAvatar == null
                        ? Center(
                            child: Text(
                              controller.initials,
                              style: AppTextStyles.h1
                                  .copyWith(color: Colors.white, fontSize: 36),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                controller.userName,
                style: AppTextStyles.h1.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                controller.userEmail,
                style: AppTextStyles.bodyM.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      controller.userRole,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
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

  // ── Stats ────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.work_outline,
                label: 'ACTIVE VACANCIES',
                value: controller.isLoadingStats.value
                    ? '...'
                    : controller.activeJobsCount.value.toString(),
                subValue: 'Published jobs',
                subValueColor: AppColors.primary,
                isTrending: controller.activeJobsCount.value > 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today_outlined,
                label: 'MEMBER SINCE',
                value: controller.memberSince,
                subValue: 'Account active',
              ),
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
    Color? subValueColor,
    bool isTrending = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h1),
          const SizedBox(height: 4),
          Row(
            children: [
              if (isTrending) ...[
                const Icon(Icons.trending_up, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  subValue,
                  style: AppTextStyles.bodyS.copyWith(
                    color: subValueColor ?? AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Settings Group ───────────────────────────────────────────────────
  Widget _buildSettingsGroup({required String title, required List<_SettingsItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(title, style: AppTextStyles.h3),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 60),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 20),
                ),
                title: Text(item.label,
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.textPrimary)),
                trailing: const Icon(Icons.chevron_right,
                    size: 20, color: AppColors.textTertiary),
                onTap: item.onTap ?? () {},
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Logout ───────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _confirmLogout(Get.context!),
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: Text(
          'Logout',
          style: AppTextStyles.button.copyWith(color: AppColors.error),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet ────────────────────────────────────────────────────
  void _showBottomSheet(BuildContext context, String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(title, style: AppTextStyles.h2),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                            backgroundColor: AppColors.cardBackground),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: content,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Sheet Contents ──────────────────────────────────────────────────
  Widget _buildPersonalInfoContent() {
    return Obx(() => Column(
          children: [
            _buildInfoTile(Icons.person_outlined, 'Full Name', controller.userName),
            _buildInfoTile(Icons.email_outlined, 'Email', controller.userEmail),
            _buildInfoTile(
              Icons.badge_outlined,
              'Role',
              controller.userRole,
            ),
            _buildInfoTile(
              Icons.calendar_today_outlined,
              'Member Since',
              controller.memberSince,
            ),
            _buildInfoTile(
              Icons.business_outlined,
              'Company ID',
              controller.user?.companyId?.toString() ?? '-',
            ),
          ],
        ));
  }

  Widget _buildSecurityContent() {
    return Obx(() {
      if (!controller.otpSent.value) {
        return Column(
          children: [
            _buildInfoTile(Icons.lock_outlined, 'Password', '••••••••'),
            _buildInfoTile(
                Icons.shield_outlined, 'Account Status', 'Active & Verified'),
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
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.key_outlined, color: Colors.white),
                label: Text(controller.isSendingOtp.value
                    ? 'Mengirim OTP...'
                    : 'Ubah Kata Sandi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
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
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline, color: Colors.white),
              label: Text(controller.isResettingPassword.value
                  ? 'Menyimpan...'
                  : 'Simpan Kata Sandi Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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


  Widget _buildNotificationContent() {
    return Column(
      children: [
        _buildSwitchTile(
            'Email Notifications', 'Receive updates via email', true),
        _buildSwitchTile(
            'Push Notifications', 'Real-time alerts on device', true),
        _buildSwitchTile(
            'Job Alerts', 'Notify when new candidates apply', false),
      ],
    );
  }

  Widget _buildLanguageContent() {
    return Column(
      children: [
        _buildRadioTile('English (US)', true),
        _buildRadioTile('Bahasa Indonesia', false),
      ],
    );
  }

  Widget _buildHelpContent() {
    return Column(
      children: [
        _buildInfoTile(
            Icons.help_center_outlined, 'Help Center', 'Browse our FAQ'),
        _buildInfoTile(Icons.support_agent_outlined, 'Contact Support',
            'Get help from our team'),
        _buildInfoTile(Icons.info_outlined, 'About App', 'Version 1.0.0 (Beta)'),
      ],
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyS),
              const SizedBox(height: 4),
              Text(value,
                  style:
                      AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.bodyS),
        value: value,
        onChanged: (val) {},
        activeColor: AppColors.primary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildRadioTile(String title, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: RadioListTile(
        title: Text(title,
            style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
        value: true,
        groupValue: selected,
        onChanged: (val) {},
        activeColor: AppColors.primary,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  Widget _buildSheetButton(String label, IconData icon,
      {bool isPrimary = true}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon,
            color: isPrimary ? Colors.white : AppColors.primary),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? AppColors.primary : AppColors.cardBackground,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.primary),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  _SettingsItem({required this.icon, required this.label, this.onTap});
}
