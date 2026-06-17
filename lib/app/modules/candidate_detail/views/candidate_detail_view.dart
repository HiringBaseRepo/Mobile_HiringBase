import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/candidate_detail_controller.dart';
import 'components/candidate_profile_card.dart';
import 'components/ai_insights_card.dart';
import 'components/application_data_card.dart';
import 'components/document_card.dart';
import 'components/status_control_card.dart';

class CandidateDetailView extends GetView<CandidateDetailController> {
  const CandidateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 70,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.surface, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          'Candidate Management',
          style: AppTextStyles.subHeader1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.surface, height: 1),
        ),
      ),
      body: Obx(() {
        final candidate = controller.candidate.value;
        if (candidate == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              CandidateProfileCard(candidate: candidate),
              if (candidate.status.toLowerCase() == 'rejected' && candidate.rejectionReason != null && candidate.rejectionReason!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Alasan Ditolak',
                            style: AppTextStyles.subHeader1.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        candidate.rejectionReason!,
                        style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              AiInsightsCard(
                score: candidate.score,
                isManualOverride: candidate.isManualOverride,
                reasoning: candidate.matchText.isNotEmpty 
                    ? candidate.matchText 
                    : "Matches technical requirements but slightly lacks specific industry experience in fintech, though overall engineering maturity is exceptional.",
              ),
              const SizedBox(height: 24),
              const ApplicationDataCard(),
              const SizedBox(height: 24),
              const DocumentCard(),
              const SizedBox(height: 24),
              const StatusControlCard(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
