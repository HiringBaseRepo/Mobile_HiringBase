import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'components/candidate_search_bar.dart';
import 'components/candidate_pipeline_header.dart';
import 'components/candidate_action_buttons.dart';
import 'components/candidate_card.dart';
import 'components/candidate_ai_promo_card.dart';
import 'components/load_more_button.dart';

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
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textSecondary, size: 20),
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
                      color: AppColors.error,
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
            const CandidateSearchBar(),
            const SizedBox(height: 25),
            const CandidatePipelineHeader(),
            const SizedBox(height: 20),
            const CandidateActionButtons(),
            const SizedBox(height: 25),
            Obx(() => Column(
              children: controller.candidates.asMap().entries.map((e) => CandidateCard(candidate: e.value, index: e.key)).toList(),
            )),
            const SizedBox(height: 20),
            const CandidateAiPromoCard(),
            const SizedBox(height: 20),
            LoadMoreButton(onPressed: () {}),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
