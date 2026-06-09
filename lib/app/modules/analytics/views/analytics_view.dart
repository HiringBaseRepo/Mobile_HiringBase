import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/analytics_controller.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Analytics Dashboard', style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () => controller.fetchJobsAndAnalytics(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchJobsAndAnalytics(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallStats(),
              const SizedBox(height: 30),
              Text('Job Statistics', style: AppTextStyles.subHeader1),
              const SizedBox(height: 15),
              _buildJobList(),
              const SizedBox(height: 30),
              Obx(() {
                if (controller.selectedJobId.value == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.touch_app_outlined, size: 64, color: AppColors.textTertiary),
                          const SizedBox(height: 10),
                          Text(
                            'Select a job to view candidates details',
                            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _buildJobDetailSection();
              }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildOverallStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Applicants Overall',
                style: AppTextStyles.bodyL.copyWith(color: Colors.white.withValues(alpha: 0.8)),
              ),
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isLoadingJobs.value) {
              return const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              );
            }
            return Text(
              '${controller.totalApplicants}',
              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 40),
            );
          }),
          const SizedBox(height: 5),
          Text(
            'Live database statistics',
            style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList() {
    return Obx(() {
      if (controller.isLoadingJobs.value) {
        return const SizedBox(
          height: 160,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.jobs.isEmpty) {
        return Container(
          width: double.infinity,
          height: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.surface),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.work_off_outlined, size: 40, color: AppColors.textTertiary),
              const SizedBox(height: 12),
              Text(
                'No jobs published yet.',
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.jobs.length,
          itemBuilder: (context, index) {
            final job = controller.jobs[index];
            final isSelected = controller.selectedJobId.value == job['id'];

            return GestureDetector(
              onTap: () => controller.selectJob(job['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isSelected ? 0.1 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.cardBackground.withValues(alpha: 0.2)
                            : Color(job['color'] as int).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.work_outline,
                        color: isSelected ? AppColors.cardBackground : Color(job['color'] as int),
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      job['title'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subHeader2.copyWith(
                        color: isSelected ? AppColors.cardBackground : AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${job['applicants']} Applicants',
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? AppColors.cardBackground.withValues(alpha: 0.8) : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildJobDetailSection() {
    final selectedJob = controller.jobs.firstWhereOrNull((j) => j['id'] == controller.selectedJobId.value);
    if (selectedJob == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail: ${selectedJob['title']}',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 20),
        _buildTabs(),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isLoadingCandidates.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final list = controller.selectedTab.value == 0
              ? controller.filteredCandidates
              : controller.rankedCandidates;

          if (list.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: Text(
                'No applicants registered for this job.',
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return Column(
            children: list.asMap().entries.map((entry) => _buildCandidateTile(entry.value, entry.key)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabItem('Pelamar', 0)),
          Expanded(child: _buildTabItem('Rank Pelamar', 1)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCandidateTile(Candidate candidate, int index) {
    final hasImg = candidate.imageUrl.isNotEmpty;
    final colorVal = Color(candidate.statusColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/candidate-detail', arguments: {
            'candidate': candidate,
            'index': index,
          });
        },
        child: Row(
          children: [
            if (controller.selectedTab.value == 1) // Show rank number
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: hasImg ? NetworkImage(candidate.imageUrl) : null,
              child: !hasImg
                  ? Text(
                      candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                      style: AppTextStyles.subHeader2.copyWith(color: AppColors.primary),
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(candidate.name, style: AppTextStyles.subHeader2),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorVal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      candidate.status.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: colorVal,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${candidate.score}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.secondary),
                ),
                Text('AI Score', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
