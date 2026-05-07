import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/candidate_detail_controller.dart';

class CandidateDetailView extends GetView<CandidateDetailController> {
  const CandidateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final candidate = controller.candidate;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Candidate Bio',
          style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(candidate),
            const SizedBox(height: 25),
            _buildInfoSection(candidate),
            const SizedBox(height: 25),
            _buildBioSection(),
            const SizedBox(height: 25),
            _buildSkillsSection(),
            const SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> candidate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(candidate['image'].toString()),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate['name'].toString(),
                  style: AppTextStyles.h3,
                ),
                Text(
                  candidate['role'].toString(),
                  style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    candidate['status'].toString(),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> candidate) {
    return Row(
      children: [
        _buildStatCard('AI Match', '${candidate['score']}%', AppColors.secondary),
        const SizedBox(width: 15),
        _buildStatCard('Experience', '5 Years', AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: AppTextStyles.subHeader1.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BIOGRAPHY',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Highly experienced professional with a strong background in software development and design. Passionate about creating user-centric applications and solving complex problems with AI integration.',
          style: AppTextStyles.bodyL.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = ['Flutter', 'Dart', 'GetX', 'Firebase', 'UI Design', 'AI Tools'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOP SKILLS',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: skills.map((skill) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              skill,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              'Interview Candidate',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
