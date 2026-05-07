import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildGreeting(),
              const SizedBox(height: 25),
              _buildStatsRow(),
              const SizedBox(height: 25),
              _buildChartSection(),
              const SizedBox(height: 25),
              _buildCandidatesSection(),
              const SizedBox(height: 100), // Space for bottom bar if needed
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment_ind,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'SmartScreen AI',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?u=sarah_admin',
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning, Sarah',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 4),
        Text(
          'Here is your daily recruitment overview.',
          style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.stats.map((stat) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  IconData(stat['icon'] as int, fontFamily: 'MaterialIcons'),
                  color: Color(stat['color'] as int),
                  size: 28,
                ),
                const SizedBox(height: 15),
                Text(
                  stat['title'].toString(),
                  style: AppTextStyles.bodyS.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'].toString(),
                  style: AppTextStyles.h2,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Applicants per Month',
            style: AppTextStyles.subHeader1,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final style = AppTextStyles.caption.copyWith(color: Colors.grey);
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = 'Jan';
                            break;
                          case 1:
                            text = 'Feb';
                            break;
                          case 2:
                            text = 'Mar';
                            break;
                          case 3:
                            text = 'Apr';
                            break;
                          case 4:
                            text = 'May';
                            break;
                          case 5:
                            text = 'Jun';
                            break;
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(text, style: style),
                        );
                      },
                      reservedSize: 22,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(0, 30, false),
                  _makeGroupData(1, 45, false),
                  _makeGroupData(2, 55, false),
                  _makeGroupData(3, 85, true),
                  _makeGroupData(4, 70, false),
                  _makeGroupData(5, 50, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, bool isSelected) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isSelected ? AppColors.chartPrimary : AppColors.chartSecondary,
          width: 35,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildCandidatesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Candidates',
              style: AppTextStyles.subHeader1,
            ),
            TextButton(
              onPressed: () {
                debugPrint('Navigating to Candidates screen...');
                Get.toNamed(Routes.CANDIDATES);
              },
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Column(
            children: controller.candidates.map((candidate) {
              return _buildCandidateCard(candidate);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateCard(Map<String, dynamic> candidate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(candidate['image'].toString()),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate['name'].toString(),
                      style: AppTextStyles.subHeader2,
                    ),
                    Text(
                      candidate['role'].toString(),
                      style: AppTextStyles.bodyS.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: candidate['status'] == 'Interview'
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  candidate['status'].toString(),
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: candidate['status'] == 'Interview'
                        ? AppColors.warning
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: (candidate['score'] as int) / 100,
                        strokeWidth: 3,
                        backgroundColor: AppColors.background,
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
                const SizedBox(width: 12),
                Text(
                  'AI Score',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Navigating to Candidate Detail: ${candidate['name']}');
                Get.toNamed('/candidate-detail', arguments: candidate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.accentText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Details',
                style: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedNavIndex.value,
        onTap: (index) {
          controller.changeNavIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
