import 'package:get/get.dart';
import '../../../data/models/candidate_model.dart';

class RankingController extends GetxController {
  final candidates = <Candidate>[].obs;
  final isLoading = false.obs;
  final jobId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is String) {
      jobId.value = Get.arguments as String;
    }
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    
    candidates.assignAll([
      const Candidate(
        id: '1',
        name: 'Sarah Jenkins',
        role: 'Senior UI Designer',
        status: 'INTERVIEW',
        score: 98,
        matchText: 'Perfect technical match...',
        appliedAt: '2 days ago',
        imageUrl: 'https://i.pravatar.cc/150?u=1',
        statusColor: 0xFF10B981,
      ),
      const Candidate(
        id: '2',
        name: 'David Miller',
        role: 'Senior UI Designer',
        status: 'TECHNICAL TEST',
        score: 92,
        matchText: 'Strong portfolio...',
        appliedAt: '3 days ago',
        imageUrl: 'https://i.pravatar.cc/150?u=2',
        statusColor: 0xFF3B82F6,
      ),
      const Candidate(
        id: '3',
        name: 'Emma Wilson',
        role: 'Senior UI Designer',
        status: 'SCREENING',
        score: 87,
        matchText: 'Good experience...',
        appliedAt: '4 days ago',
        imageUrl: 'https://i.pravatar.cc/150?u=3',
        statusColor: 0xFFF59E0B,
      ),
      const Candidate(
        id: '4',
        name: 'James Brown',
        role: 'Senior UI Designer',
        status: 'APPLIED',
        score: 75,
        matchText: 'Junior level skills...',
        appliedAt: '5 days ago',
        imageUrl: 'https://i.pravatar.cc/150?u=4',
        statusColor: 0xFF64748B,
      ),
    ]);
    
    isLoading.value = false;
  }
}
