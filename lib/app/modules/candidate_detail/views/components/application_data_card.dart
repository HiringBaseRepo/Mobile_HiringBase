import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';

class ApplicationDataCard extends StatelessWidget {
  const ApplicationDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.person, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'APPLICATION DATA',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem('FULL NAME', 'Alex Rivera'),
              const SizedBox(height: 20),
              _buildInfoItem('EMAIL', 'alex.rivera@example.com'),
              const SizedBox(height: 20),
              _buildInfoItem('PHONE', '+1 (555) 012-3456'),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PORTFOLIO', style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('alexrivera.dev', style: AppTextStyles.bodyM.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: AppColors.surface),
              const SizedBox(height: 24),
              _buildSectionItem('EDUCATION', 'M.S. in Computer Science', 'Stanford University, 2018'),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WORK EXPERIENCE', style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                  const SizedBox(height: 8),
                  _buildExperienceItem('Senior Software Engineer', 'TechFlow Solutions • 2020 - Present'),
                  const SizedBox(height: 12),
                  _buildExperienceItem('Full Stack Developer', 'Innovate Apps • 2018 - 2020'),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SKILLS', style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSkillChip('React'),
                      _buildSkillChip('TypeScript'),
                      _buildSkillChip('Node.js'),
                      _buildSkillChip('PostgreSQL'),
                      _buildSkillChip('AWS'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSectionItem(String label, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w700)),
        Text(subtitle, style: AppTextStyles.bodyS),
      ],
    );
  }

  Widget _buildExperienceItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w700)),
        Text(subtitle, style: AppTextStyles.bodyS.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }
}
