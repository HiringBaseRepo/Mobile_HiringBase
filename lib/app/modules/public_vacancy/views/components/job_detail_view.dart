import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../controllers/public_vacancy_controller.dart';
import 'job_detail_skeleton.dart';

class JobDetailView extends GetView<PublicVacancyController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vacancy = controller.selectedVacancy.value;
      if (vacancy == null) {
        return const JobDetailSkeleton();
      }
      
      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBentoHero(vacancy),
                    const SizedBox(height: 32),
                    _buildAboutSection(vacancy.description),
                    if (vacancy.responsibilities != null && vacancy.responsibilities!.trim().isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _buildResponsibilitiesSection(vacancy.responsibilities),
                    ],
                    const SizedBox(height: 32),
                    _buildRequirementsSection(vacancy.requirements),
                    const SizedBox(height: 32),
                    _buildBenefitsSection(vacancy.benefits),
                    const SizedBox(height: 32),
                    _buildActionCard(),
                    const SizedBox(height: 32),
                    _buildCompanySnapshot(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
        onPressed: () => controller.selectedVacancy.value = null,
      ),
      title: Text("Job Details", style: AppTextStyles.subHeader1),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBentoHero(vacancy) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  (vacancy.companyName ?? "HiringBase Company").toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(vacancy.title, style: AppTextStyles.h1.copyWith(fontSize: 28)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildHeroChip(Icons.location_on_outlined, vacancy.location),
              _buildHeroChip(Icons.schedule_outlined, vacancy.employmentTypeLabel),
              _buildHeroChip(Icons.payments_outlined, vacancy.salaryDisplay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.description_outlined, "About the Role"),
        const SizedBox(height: 16),
        Text(
          description,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  String _formatRequirement(VacancyRequirement req) {
    final name = req.name;
    final val = req.value;
    final isReq = req.isRequired ? ' (Wajib)' : '';
    
    if (req.category.toLowerCase() == 'skill') {
      return '$name$isReq';
    }
    if (req.category.toLowerCase() == 'education') {
      return 'Pendidikan: $val$isReq';
    }
    if (req.category.toLowerCase() == 'experience') {
      return 'Pengalaman: $val$isReq';
    }
    return '$name: $val$isReq';
  }

  Widget _buildResponsibilitiesSection(String? responsibilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.assignment_outlined, "Responsibilities"),
        const SizedBox(height: 16),
        Text(
          responsibilities ?? '',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsSection(List<VacancyRequirement> requirements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.fact_check_outlined, "Requirements"),
        const SizedBox(height: 16),
        if (requirements.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Kualifikasi umum yang relevan dengan posisi.",
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...requirements.map((req) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatRequirement(req),
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildBenefitsSection(String? benefitsText) {
    final List<String> list = [];
    if (benefitsText != null && benefitsText.trim().isNotEmpty) {
      list.addAll(
        benefitsText
            .split(RegExp(r'[\n\r,;]'))
            .map((s) {
              var trimmed = s.trim();
              if (trimmed.startsWith('-') || trimmed.startsWith('*') || trimmed.startsWith('•')) {
                trimmed = trimmed.substring(1).trim();
              }
              return trimmed;
            })
            .where((s) => s.isNotEmpty)
      );
    }
    
    // Fallback default benefits if none specified
    if (list.isEmpty) {
      list.addAll([
        'Asuransi Kesehatan',
        'Waktu Kerja Fleksibel',
        'Pengembangan Karir',
        'Lingkungan Kerja Suportif'
      ]);
    }

    final icons = [
      Icons.medical_services_outlined,
      Icons.beach_access_outlined,
      Icons.school_outlined,
      Icons.home_work_outlined,
      Icons.payments_outlined,
      Icons.work_outline,
    ];
    final colors = [
      Colors.green,
      Colors.purple,
      Colors.amber,
      Colors.blue,
      Colors.orange,
      Colors.teal,
    ];

    final List<Widget> rows = [];
    for (var i = 0; i < list.length; i += 2) {
      final benefit1 = list[i];
      final icon1 = icons[i % icons.length];
      final color1 = colors[i % colors.length];

      final hasSecond = i + 1 < list.length;
      final benefit2 = hasSecond ? list[i + 1] : null;
      final icon2 = hasSecond ? icons[(i + 1) % icons.length] : null;
      final color2 = hasSecond ? colors[(i + 1) % colors.length] : null;

      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildBenefitCard(benefit1, icon1, color1),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: benefit2 != null && icon2 != null && color2 != null
                  ? _buildBenefitCard(benefit2, icon2, color2)
                  : const SizedBox(),
            ),
          ],
        ),
      );

      if (i + 2 < list.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.card_giftcard_rounded, "Benefits"),
        const SizedBox(height: 16),
        ...rows,
      ],
    );
  }

  Widget _buildBenefitCard(String benefitLabel, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefitLabel,
              style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ready to Apply?", style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            "Join a team of passionate engineers building the future of hiring.",
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
              child: Text("Apply for this Position", style: AppTextStyles.button.copyWith(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "APPLICATION ENDS IN 12 DAYS",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySnapshot() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "COMPANY SNAPSHOT",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          _buildSnapshotItem("Team Size", "45 People"),
          _buildSnapshotItem("Funding", "Series A"),
          _buildSnapshotItem("Applicants", "240+"),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }
}
