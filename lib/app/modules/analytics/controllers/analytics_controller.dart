import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';

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

  final candidates = <Candidate>[
    const Candidate(
      id: '1',
      name: 'Alex Rivera',
      role: 'Senior Software Engineer',
      status: 'Interview',
      score: 92,
      matchText: 'Top 5%',
      appliedAt: '2h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=alex',
      statusColor: 0xFF3B82F6,
    ),
    const Candidate(
      id: '2',
      name: 'Sarah Chen',
      role: 'Senior Software Engineer',
      status: 'Reviewed',
      score: 85,
      matchText: 'Strong Fit',
      appliedAt: '5h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=sarah',
      statusColor: 0xFF64748B,
    ),
    const Candidate(
      id: '3',
      name: 'Jordan Lee',
      role: 'UI/UX Designer',
      status: 'Reviewed',
      score: 78,
      matchText: 'Moderate',
      appliedAt: '12h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=jordan',
      statusColor: 0xFF64748B,
    ),
    const Candidate(
      id: '4',
      name: 'Budi Santoso',
      role: 'Senior Software Engineer',
      status: 'Interview',
      score: 95,
      matchText: 'Top 1%',
      appliedAt: '1d ago',
      imageUrl: 'https://i.pravatar.cc/150?u=budi',
      statusColor: 0xFF3B82F6,
    ),
  ].obs;

  // Mock mapping jobId to candidates for simplicity
  final jobCandidates = {
    '1': ['1', '2', '4'],
    '2': ['3'],
  };

  List<Candidate> get filteredCandidates {
    if (selectedJobId.value == null) return [];
    final ids = jobCandidates[selectedJobId.value] ?? [];
    return candidates.where((c) => ids.contains(c.id)).toList();
  }

  List<Candidate> get rankedCandidates {
    final list = List<Candidate>.from(filteredCandidates);
    list.sort((a, b) => b.score.compareTo(a.score));
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
