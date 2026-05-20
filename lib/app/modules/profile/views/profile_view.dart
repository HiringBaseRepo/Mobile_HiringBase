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
                        onTap: () => _showBottomSheet(context, 'Personal Info', _buildPersonalInfoContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.security_outlined, 
                        label: 'Security & Password',
                        onTap: () => _showBottomSheet(context, 'Security & Password', _buildSecurityContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.history_outlined, 
                        label: 'Aktivitas Saya',
                        onTap: () => Get.toNamed('/aktivitas'),
                      ),
                      _SettingsItem(
                        icon: Icons.notifications_none_outlined, 
                        label: 'Notifications',
                        onTap: () => _showBottomSheet(context, 'Notifications', _buildNotificationContent()),
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
                        onTap: () => _showBottomSheet(context, 'Language', _buildLanguageContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.dark_mode_outlined, 
                        label: 'Appearance',
                        onTap: () => _showBottomSheet(context, 'Appearance', _buildAppearanceContent()),
                      ),
                      _SettingsItem(
                        icon: Icons.help_outline, 
                        label: 'Help & Support',
                        onTap: () => _showBottomSheet(context, 'Help & Support', _buildHelpContent()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }


  Widget _buildPremiumHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBy-tA4Aj8lZ78Ngq7zG5ti1aOyPpudRlsLOV3V7r3ijyVQG2hWBoP8l-yJLR6SusgYWi21NoaR1a8Pds3vAAoYHJqcnegyZGWIX5498GCSXnKN6xSHpa5ivVc4Ud4bWLI9FuxiFkwDe2WEuM4BSS7mhSPOWKSxjdnTMIqs4ScKmEj-I9qBlXFlZ64OEw3MwLEhJBVjvWjkTrkB3yrZEgj1b3Scpq1QEg0a-yqWaQ-e9-vCDeSuKWhZotPLW1V0s-HZhWNrBEAK_IG0'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 18, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Alex Rivers',
            style: AppTextStyles.h1.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Talent Acquisition Lead',
            style: AppTextStyles.bodyM.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'VERIFIED RECRUITER',
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
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: Text(
          'Logout',
          style: AppTextStyles.button.copyWith(color: AppColors.error),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.error.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.work_outline,
            label: 'ACTIVE VACANCIES',
            value: '12',
            subValue: '+2 this week',
            subValueColor: AppColors.primary,
            isTrending: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.groups_outlined,
            label: 'TOTAL CANDIDATES',
            value: '1,240',
            subValue: 'Across all pipelines',
          ),
        ),
      ],
    );
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
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                  maxLines: 1,
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
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({required String title, required List<_SettingsItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
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
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 20),
                ),
                title: Text(item.label, style: AppTextStyles.button.copyWith(color: AppColors.textPrimary)),
                trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
                onTap: item.onTap ?? () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              );
            },
          ),
        ],
      ),
    );
  }

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
                    color: AppColors.textTertiary.withOpacity(0.3),
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
                          backgroundColor: AppColors.cardBackground,
                        ),
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

  Widget _buildPersonalInfoContent() {
    return Column(
      children: [
        _buildInfoTile(Icons.person_outlined, 'Full Name', 'Alex Rivers'),
        _buildInfoTile(Icons.email_outlined, 'Email', 'alex.rivers@example.com'),
        _buildInfoTile(Icons.phone_outlined, 'Phone', '+62 812 3456 7890'),
        _buildInfoTile(Icons.location_on_outlined, 'Location', 'Jakarta, Indonesia'),
        _buildInfoTile(Icons.work_outlined, 'Position', 'Talent Acquisition Lead'),
        const SizedBox(height: 32),
        _buildSheetButton('Edit Profile', Icons.edit_outlined, isPrimary: true),
      ],
    );
  }

  Widget _buildSecurityContent() {
    return Column(
      children: [
        _buildInfoTile(Icons.lock_outlined, 'Password', 'Last changed 3 months ago'),
        _buildInfoTile(Icons.phonelink_lock_outlined, 'Two-Factor Auth', 'Enabled'),
        _buildInfoTile(Icons.devices_outlined, 'Active Sessions', '2 Devices'),
        const SizedBox(height: 32),
        _buildSheetButton('Change Password', Icons.key_outlined, isPrimary: true),
        const SizedBox(height: 12),
        _buildSheetButton('Privacy Settings', Icons.privacy_tip_outlined, isPrimary: false),
      ],
    );
  }

  Widget _buildNotificationContent() {
    return Column(
      children: [
        _buildSwitchTile('Email Notifications', 'Receive updates via email', true),
        _buildSwitchTile('Push Notifications', 'Real-time alerts on device', true),
        _buildSwitchTile('Job Alerts', 'Notify when new candidates apply', false),
        _buildSwitchTile('Weekly Reports', 'Summary of recruitment activity', true),
      ],
    );
  }

  Widget _buildLanguageContent() {
    return Column(
      children: [
        _buildRadioTile('English (US)', true),
        _buildRadioTile('Bahasa Indonesia', false),
        _buildRadioTile('English (UK)', false),
        _buildRadioTile('Français', false),
        _buildRadioTile('Deutsch', false),
        _buildRadioTile('Español', false),
      ],
    );
  }

  Widget _buildAppearanceContent() {
    return Column(
      children: [
        _buildRadioTile('Light Mode', false),
        _buildRadioTile('Dark Mode', true),
        _buildRadioTile('System Default', false),
      ],
    );
  }

  Widget _buildHelpContent() {
    return Column(
      children: [
        _buildInfoTile(Icons.help_center_outlined, 'Help Center', 'Browse our FAQ'),
        _buildInfoTile(Icons.support_agent_outlined, 'Contact Support', 'Get help from our team'),
        _buildInfoTile(Icons.description_outlined, 'Terms of Service', 'Read our policies'),
        _buildInfoTile(Icons.info_outlined, 'About App', 'Version 1.0.4'),
        const SizedBox(height: 32),
        _buildSheetButton('Send Feedback', Icons.feedback_outlined, isPrimary: true),
      ],
    );
  }

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
              Text(value, style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
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
        title: Text(title, style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.bodyS),
        value: value,
        onChanged: (val) {},
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        title: Text(title, style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600)),
        value: true,
        groupValue: selected,
        onChanged: (val) {},
        activeColor: AppColors.primary,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  Widget _buildSheetButton(String label, IconData icon, {bool isPrimary = true}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: isPrimary ? Colors.white : AppColors.primary),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.cardBackground,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : const BorderSide(color: AppColors.primary),
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
