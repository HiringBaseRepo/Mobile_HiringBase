import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'package:uifrontendmobile/app/core/widgets/pagination_footer.dart';
import 'package:uifrontendmobile/app/core/widgets/error_retry_widget.dart';
import 'components/candidate_search_bar.dart';
import 'components/candidate_card.dart';
import 'components/candidate_ai_promo_card.dart';

class CandidatesView extends GetView<CandidatesController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: Obx(() => controller.isSelectionMode.value
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                onPressed: () => controller.toggleSelectionMode(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textSecondary, size: 20),
                onPressed: () => Get.back(),
              ),
        ),
        title: Obx(() => Text(
          controller.isSelectionMode.value
              ? '${controller.selectedIds.length} Terpilih'
              : 'Kandidat Terbaru',
          style: AppTextStyles.subHeader1.copyWith(color: AppColors.primary),
        )),
        centerTitle: true,
        actions: [
          Obx(() => controller.isSelectionMode.value
              ? IconButton(
                  icon: Text(
                    controller.allSelected ? 'Batal Pilih' : 'Pilih Semua',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => controller.selectAll(),
                )
              : IconButton(
                  icon: const Icon(Icons.checklist, color: AppColors.textTertiary),
                  onPressed: () => controller.toggleSelectionMode(),
                ),
          ),
          if (!controller.isSelectionMode.value) ...[
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.textTertiary),
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
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            controller.loadMore();
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CandidateSearchBar(),
              const SizedBox(height: 16),
              _StatusFilterTabs(),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.errorMessage.value.isNotEmpty) {
                  return ErrorRetryWidget(
                    message: controller.errorMessage.value,
                    onRetry: () => controller.fetchCandidates(refresh: true),
                  );
                }
                return Column(
                  children: controller.filteredCandidates.asMap().entries.map((e) => CandidateCard(candidate: e.value, index: e.key)).toList(),
                );
              }),
              const SizedBox(height: 20),
              const CandidateAiPromoCard(),
              const SizedBox(height: 20),
              Obx(() => PaginationFooter(
                isLoading: controller.isLoadingMore.value,
                hasMore: controller.hasMore.value,
                noMoreText: 'Semua kandidat telah dimuat',
              )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => controller.isSelectionMode.value
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.selectedIds.isEmpty || controller.isBatchRunning.value
                            ? null
                            : () => controller.runBatchScreening(),
                        icon: controller.isBatchRunning.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                              )
                            : const Icon(Icons.smart_toy_outlined, size: 18),
                        label: Text(
                          controller.isBatchRunning.value
                              ? 'Memproses...'
                              : 'Jalankan Skrining AI (${controller.selectedIds.length})',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.textTertiary.withValues(alpha: 0.3),
                          disabledForegroundColor: AppColors.textTertiary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const AppBottomNav()),
    );
  }
}

class _StatusFilterTabs extends GetView<CandidatesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.statusTabs.map((tab) {
          final isActive = controller.activeFilter.value == tab;
          final String label;
          switch (tab) {
            case 'all':
              label = 'Semua';
              break;
            case 'applied':
              label = 'Baru';
              break;
            case 'under_review':
              label = 'Ditinjau';
              break;
            case 'interview':
              label = 'Wawancara';
              break;
            case 'hired':
              label = 'Diterima';
              break;
            case 'rejected':
              label = 'Ditolak';
              break;
            default:
              label = tab.replaceAll('_', ' ').capitalizeFirst ?? tab;
          }
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => controller.changeFilter(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.bodyS.copyWith(
                    color: isActive ? AppColors.white : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}
