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
                      _SettingsItem(icon: Icons.person_outline, label: 'Personal Info'),
                      _SettingsItem(icon: Icons.security_outlined, label: 'Security & Password'),
                      _SettingsItem(
                        icon: Icons.history_outlined, 
                        label: 'Aktivitas Saya',
                        onTap: () => Get.toNamed('/aktivitas'),
                      ),
                      _SettingsItem(icon: Icons.notifications_none_outlined, label: 'Notifications'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsGroup(
                    title: 'System Preferences',
                    items: [
                      _SettingsItem(icon: Icons.language_outlined, label: 'Language'),
                      _SettingsItem(icon: Icons.dark_mode_outlined, label: 'Appearance'),
                      _SettingsItem(icon: Icons.help_outline, label: 'Help & Support'),
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
                leading: Icon(item.icon, color: AppColors.textSecondary),
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
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  _SettingsItem({required this.icon, required this.label, this.onTap});
}
