import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'components/profile_header.dart';
import 'components/profile_info_card.dart';
import 'components/profile_change_password_section.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
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
                            context, 'Security & Password', const ProfileChangePasswordSection()),
                      ),
                      _SettingsItem(
                        icon: Icons.history_outlined,
                        label: 'Aktivitas Saya',
                        onTap: () => Get.toNamed(Routes.AKTIVITAS),
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

  // ── Stats ────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: ProfileStatCard(
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
              child: ProfileStatCard(
                icon: Icons.calendar_today_outlined,
                label: 'MEMBER SINCE',
                value: controller.memberSince,
                subValue: 'Account active',
              ),
            ),
          ],
        ));
  }

  // ── Settings Group ───────────────────────────────────────────────────
  Widget _buildSettingsGroup({required String title, required List<_SettingsItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(title, style: AppTextStyles.h3),
          ),
          const Divider(height: 1),
          // Menggunakan mapping Column untuk menghindari shrinkWrap: true di ListView.separated
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0) const Divider(height: 1, indent: 60),
                ListTile(
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
                ),
              ],
            );
          }),
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
              foregroundColor: AppColors.white,
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
      backgroundColor: AppColors.transparent,
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
            ProfileInfoTile(icon: Icons.person_outlined, label: 'Full Name', value: controller.userName),
            ProfileInfoTile(icon: Icons.email_outlined, label: 'Email', value: controller.userEmail),
            ProfileInfoTile(
              icon: Icons.badge_outlined,
              label: 'Role',
              value: controller.userRole,
            ),
            ProfileInfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Member Since',
              value: controller.memberSince,
            ),
            ProfileInfoTile(
              icon: Icons.business_outlined,
              label: 'Company ID',
              value: controller.user?.companyId?.toString() ?? '-',
            ),
          ],
        ));
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
        ProfileInfoTile(
            icon: Icons.help_center_outlined, label: 'Help Center', value: 'Browse our FAQ'),
        ProfileInfoTile(icon: Icons.support_agent_outlined, label: 'Contact Support',
            value: 'Get help from our team'),
        ProfileInfoTile(icon: Icons.info_outlined, label: 'About App', value: 'Version 1.0.0 (Beta)'),
      ],
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────
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
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  _SettingsItem({required this.icon, required this.label, this.onTap});
}
