import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final selectedJobId = RxnString();
  final selectedTab = 0.obs; // 0: Pelamar, 1: Rank Pelamar

  final jobs = [
    {
      'id': '1',
      'title': 'Senior Software Engineer',
      'applicants': 45,
      'color': 0xFF3B82F6,
    },
    {
      'id': '2',
      'title': 'UI/UX Designer',
      'applicants': 32,
      'color': 0xFF8B5CF6,
    },
    {
      'id': '3',
      'title': 'Product Manager',
      'applicants': 18,
      'color': 0xFF10B981,
    },
    {
      'id': '4',
      'title': 'Mobile Developer',
      'applicants': 25,
      'color': 0xFFF59E0B,
    },
  ].obs;

  final candidates = [
    {
      'name': 'Alex Rivera',
      'jobId': '1',
      'score': 92,
      'image': 'https://i.pravatar.cc/150?u=alex',
      'status': 'Interview',
    },
    {
      'name': 'Sarah Chen',
      'jobId': '1',
      'score': 85,
      'image': 'https://i.pravatar.cc/150?u=sarah',
      'status': 'Reviewed',
    },
    {
      'name': 'Jordan Lee',
      'jobId': '2',
      'score': 78,
      'image': 'https://i.pravatar.cc/150?u=jordan',
      'status': 'Reviewed',
    },
    {
      'name': 'Budi Santoso',
      'jobId': '1',
      'score': 95,
      'image': 'https://i.pravatar.cc/150?u=budi',
      'status': 'Interview',
    },
    {
      'name': 'Siti Aminah',
      'jobId': '1',
      'score': 88,
      'image': 'https://i.pravatar.cc/150?u=siti',
      'status': 'Reviewed',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredCandidates {
    if (selectedJobId.value == null) return [];
    return candidates.where((c) => c['jobId'] == selectedJobId.value).toList();
  }

  List<Map<String, dynamic>> get rankedCandidates {
    final list = List<Map<String, dynamic>>.from(filteredCandidates);
    list.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return list;
  }

  void selectJob(String? id) {
    if (selectedJobId.value == id) {
      selectedJobId.value = null;
    } else {
      selectedJobId.value = id;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  int get totalApplicants => jobs.fold(0, (sum, item) => sum + (item['applicants'] as int));
}
