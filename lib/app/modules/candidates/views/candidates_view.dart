import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import '../controllers/candidates_controller.dart';

class CandidatesView extends GetView<CandidatesController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Recent Candidates',
          style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.grey),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                )
              ],
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 25),
            _buildPipelineHeader(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 25),
            Obx(() => Column(
              children: controller.candidates.map((candidate) => _buildCandidateCard(candidate)).toList(),
            )),
            const SizedBox(height: 20),
            _buildAiPromoCard(),
            const SizedBox(height: 20),
            _buildLoadMoreButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Quick find candidate..',
          hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPipelineHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVE PIPELINE',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Screening Queue',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 8),
        Text(
          'Reviewing 24 new applicants for Senior Engineering roles.',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, size: 18),
          label: const Text('Filter'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: BorderSide(color: AppColors.surface),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Candidate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateCard(Map<String, dynamic> candidate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(candidate['image'].toString()),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cardBackground, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate['name'].toString(),
                      style: AppTextStyles.subHeader1,
                    ),
                    Text(
                      candidate['role'].toString(),
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(candidate['statusColor'] as int).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  candidate['status'].toString(),
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(candidate['statusColor'] as int),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        value: (candidate['score'] as int) / 100,
                        strokeWidth: 4,
                        backgroundColor: Colors.grey.shade300,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      candidate['score'].toString(),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI SCORE',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        candidate['matchText'].toString(),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Applied',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      candidate['appliedAt'].toString(),
                      style: AppTextStyles.bodyS.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Navigating to Candidate Detail: ${candidate['name']}');
                    Get.toNamed('/candidate-detail', arguments: candidate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'View Details',
                    style: AppTextStyles.button.copyWith(color: AppColors.cardBackground),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surface),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: AppColors.textTertiary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiPromoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            'Smart screening is active',
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'AI has analyzed 120+ applications this week, saving your team 14 hours of manual review.',
            style: AppTextStyles.bodyM.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'View AI Reports',
                style: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.keyboard_arrow_down),
        label: const Text('Load More Candidates'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: AppColors.surface),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        ),
      ),
    );
  }
}
