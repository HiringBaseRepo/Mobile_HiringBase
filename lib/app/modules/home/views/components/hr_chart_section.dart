import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import '../../controllers/home_controller.dart';

class HrChartSection extends StatelessWidget {
  const HrChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
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
            child: Obx(() {
              // Calculate monthly counts dynamically based on loaded candidates
              final counts = List.filled(6, 0.0);
              
              // Map months: Jun=5, May=4, Apr=3, Mar=2, Feb=1, Jan=0 (or whatever current month range is)
              // Since it might be empty, if counts is all zero we can show a subtle placeholder or small indicators
              for (var c in controller.candidates) {
                // simple parse logic from relative appliedAt or date
                final dateStr = c.appliedAt;
                if (dateStr.contains('Jan')) counts[0]++;
                else if (dateStr.contains('Feb')) counts[1]++;
                else if (dateStr.contains('Mar')) counts[2]++;
                else if (dateStr.contains('Apr')) counts[3]++;
                else if (dateStr.contains('May')) counts[4]++;
                else if (dateStr.contains('Jun')) counts[5]++;
                else {
                  // Fallback: distribute or add to current month (Jun)
                  counts[5]++;
                }
              }

              // Find maximum count for charting scale (min 10)
              double maxVal = 10;
              for (var val in counts) {
                if (val > maxVal) maxVal = val;
              }
              maxVal = (maxVal / 5).ceil() * 5.0; // round up to multiple of 5

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final style = AppTextStyles.caption.copyWith(color: AppColors.textSecondary);
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
                  barGroups: List.generate(6, (index) {
                    final val = counts[index];
                    return _makeGroupData(index, val, index == 5);
                  }),
                ),
              );
            }),
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
          toY: y == 0 ? 0.3 : y, // show a tiny dot if zero so the chart looks premium
          color: isSelected ? AppColors.chartPrimary : AppColors.chartSecondary,
          width: 35,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
