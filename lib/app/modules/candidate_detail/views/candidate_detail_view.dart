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
import 'components/screening_progress_card.dart';

import 'components/candidate_detail_skeleton.dart';
import 'components/warning_card.dart';

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
        if (controller.isLoading.value || controller.candidate.value == null) {
          return const CandidateDetailSkeleton();
        }
        final candidate = controller.candidate.value!;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              CandidateProfileCard(candidate: candidate),
              // Screening in-progress states
              if (['applied', 'doc_check', 'ai_processing'].contains(candidate.status.toLowerCase())) ...[
                const SizedBox(height: 24),
                ScreeningProgressCard(status: candidate.status.toLowerCase()),
              ],
              // Screening failure states
              if (['doc_failed', 'knockout'].contains(candidate.status.toLowerCase())) ...[
                const SizedBox(height: 24),
                ScreeningProgressCard(
                  status: candidate.status.toLowerCase(),
                  rejectionReason: candidate.rejectionReason,
                ),
              ],
              // Rejection reason (rejected status)
              if (candidate.status.toLowerCase() == 'rejected' && candidate.rejectionReason != null && candidate.rejectionReason!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'ALASAN DITOLAK',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...candidate.rejectionReason!
                    .split('\n')
                    .where((line) => line.trim().isNotEmpty)
                    .map((line) => WarningCard(rawMessage: line)),
              ],
              // AI Insights — only show when score is available
              if (candidate.score > 0) ...[
                const SizedBox(height: 24),
                AiInsightsCard(
                  scoreData: candidate.scoreData,
                ),
              ],
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
