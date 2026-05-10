import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/widgets/app_bottom_nav.dart';
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
        child: RefreshIndicator(
          onRefresh: controller.fetchJobs,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredJobs = controller.filteredJobs;
                  
                  if (filteredJobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Icon(Icons.work_off_outlined, size: 64, color: AppColors.textTertiary),
                          const SizedBox(height: 16),
                          Text('No jobs found', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      return JobListCard(job: filteredJobs[index]);
                    },
                  );
                }),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
