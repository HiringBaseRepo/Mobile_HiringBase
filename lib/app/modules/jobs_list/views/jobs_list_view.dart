import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
import 'package:uifrontendmobile/app/core/widgets/pagination_footer.dart';
import 'package:uifrontendmobile/app/core/widgets/error_retry_widget.dart';
import '../controllers/jobs_list_controller.dart';
import 'components/job_list_header.dart';
import 'components/job_filter_bar.dart';
import 'components/job_list_card.dart';

class JobsListView extends GetView<JobsListController> {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMore();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () => controller.fetchJobs(refresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const JobsListHeader(),
                  const SizedBox(height: 24),
                  const JobFilterBar(),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (controller.isLoading.value && controller.jobs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.errorMessage.value != null) {
                      return ErrorRetryWidget(
                        message: controller.errorMessage.value!,
                        onRetry: () => controller.fetchJobs(refresh: true),
                      );
                    }

                    final filteredJobs = controller.filteredJobs;
                    
                    if (filteredJobs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            const Icon(Icons.work_off_outlined, size: 64, color: AppColors.textTertiary),
                            const SizedBox(height: 16),
                            Text('No jobs found', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        ...filteredJobs.map((job) => JobListCard(job: job)),
                        const SizedBox(height: 20),
                        PaginationFooter(
                          isLoading: controller.isLoadingMore.value,
                          hasMore: controller.hasMore.value,
                          noMoreText: 'Semua lowongan telah dimuat',
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
