import 'package:get/get.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';


class CandidatesController extends GetxController {
  final candidates = [
    {
      'name': 'Alex Rivera',
      'role': 'Senior Developer',
      'status': 'INTERVIEW',
      'score': 92,
      'matchText': 'Top 5% Match',
      'appliedAt': '2h ago',
      'image': 'https://i.pravatar.cc/150?u=alex',
      'statusColor': 0xFF3B82F6,
    },
    {
      'name': 'Sarah Chen',
      'role': 'UX Architect',
      'status': 'REVIEWED',
      'score': 86,
      'matchText': 'Strong Fit',
      'appliedAt': '5h ago',
      'image': 'https://i.pravatar.cc/150?u=sarah',
      'statusColor': 0xFF6B7280,
    },
    {
      'name': 'Marcus Thorne',
      'role': 'Product Manager',
      'status': 'NEW',
      'score': 72,
      'matchText': 'Moderate',
      'appliedAt': '12h ago',
      'image': 'https://i.pravatar.cc/150?u=marcus',
      'statusColor': 0xFFF97316,
    },
    {
      'name': 'Elena Novak',
      'role': 'Data Scientist',
      'status': 'ACCEPTED',
      'score': 96,
      'matchText': 'Expert Match',
      'appliedAt': '1d ago',
      'image': 'https://i.pravatar.cc/150?u=elena',
      'statusColor': 0xFF10B981,
    },
    {
      'name': 'Jordan Smyth',
      'role': 'DevOps Engineer',
      'status': 'INTERVIEW',
      'score': 81,
      'matchText': 'Strong Match',
      'appliedAt': '2d ago',
      'image': 'https://i.pravatar.cc/150?u=jordan_s',
      'statusColor': 0xFF3B82F6,
    },
  ].obs;

  final selectedNavIndex = 1.obs; // Index 1 for Candidates

  void updateCandidateStatus(int index, String status) {
    String colorCode = '0xFF6B7280'; // Default Gray (Review)
    
    switch (status.toUpperCase()) {
      case 'REVIEW':
        colorCode = '0xFF6B7280';
        break;
      case 'INTERVIEW':
        colorCode = '0xFF3B82F6';
        break;
      case 'DITERIMA':
        colorCode = '0xFF10B981';
        break;
      case 'DITOLAK':
        colorCode = '0xFFEF4444';
        break;
    }

    candidates[index] = {
      ...candidates[index],
      'status': status.toUpperCase(),
      'statusColor': int.parse(colorCode),
    };
    candidates.refresh();
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
    if (index == 1) Get.toNamed('/jobs');
  }
}
