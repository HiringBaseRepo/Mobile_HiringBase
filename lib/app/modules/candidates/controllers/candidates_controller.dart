import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';

class CandidatesController extends GetxController {
  final _navService = Get.find<NavigationService>();

  final candidates = <Candidate>[
    const Candidate(
      id: '1',
      name: 'Alex Rivera',
      role: 'Senior Developer',
      status: 'INTERVIEW',
      score: 92,
      matchText: 'Top 5% Match',
      appliedAt: '2h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=alex',
      statusColor: 0xFF3B82F6,
    ),
    const Candidate(
      id: '2',
      name: 'Sarah Chen',
      role: 'UX Architect',
      status: 'REVIEWED',
      score: 86,
      matchText: 'Strong Fit',
      appliedAt: '5h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=sarah',
      statusColor: 0xFF64748B,
    ),
    const Candidate(
      id: '3',
      name: 'Marcus Thorne',
      role: 'Product Manager',
      status: 'APPLIED',
      score: 0,
      matchText: 'Pending Screening',
      appliedAt: '12h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=marcus',
      statusColor: 0xFFF97316,
    ),
    const Candidate(
      id: '4',
      name: 'Elena Novak',
      role: 'Data Scientist',
      status: 'ACCEPTED',
      score: 96,
      matchText: 'Expert Match',
      appliedAt: '1d ago',
      imageUrl: 'https://i.pravatar.cc/150?u=elena',
      statusColor: 0xFF10B981,
    ),
    const Candidate(
      id: '5',
      name: 'Jordan Smyth',
      role: 'DevOps Engineer',
      status: 'INTERVIEW',
      score: 81,
      matchText: 'Strong Match',
      appliedAt: '2d ago',
      imageUrl: 'https://i.pravatar.cc/150?u=jordan_s',
      statusColor: 0xFF3B82F6,
    ),
  ].obs;

  int get selectedNavIndex => _navService.selectedIndex.value;

  void updateCandidateStatus(int index, String status) {
    Color statusColor = AppColors.textSecondary;
    
    switch (status.toUpperCase()) {
      case 'REVIEW':
        statusColor = AppColors.textSecondary;
        break;
      case 'INTERVIEW':
        statusColor = AppColors.info;
        break;
      case 'DITERIMA':
      case 'ACCEPTED':
        statusColor = AppColors.success;
        break;
      case 'DITOLAK':
      case 'REJECTED':
        statusColor = AppColors.error;
        break;
    }

    candidates[index] = candidates[index].copyWith(
      status: status.toUpperCase(),
      statusColor: statusColor.toARGB32(),
    );
  }

  void changeNavIndex(int index) {
    _navService.changeTo(index);
  }
}
