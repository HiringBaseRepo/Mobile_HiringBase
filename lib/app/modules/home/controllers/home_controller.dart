import 'package:get/get.dart';


import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class HomeController extends GetxController {
  final _navService = Get.find<NavigationService>();

  final stats = [
    {'title': 'Total Applicants', 'value': '260', 'icon': 0xe491, 'color': 0xFF3B82F6}, // person_outline
    {'title': 'Active Listings', 'value': '8', 'icon': 0xe11e, 'color': 0xFF8B5CF6}, // work_outline
    {'title': 'Passed Screen', 'value': '67', 'icon': 0xe156, 'color': 0xFF10B981}, // check_circle_outline
  ].obs;

  final candidates = <Candidate>[
    const Candidate(
      id: '1',
      name: 'Alex Rivera',
      role: 'Senior Dev',
      status: 'Interview',
      score: 92,
      matchText: 'Top 5% Match',
      appliedAt: '2h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=alex',
      statusColor: 0xFF3B82F6,
    ),
    const Candidate(
      id: '2',
      name: 'Sarah Chen',
      role: 'UI Designer',
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
      role: 'Product Manager',
      status: 'Reviewed',
      score: 78,
      matchText: 'Moderate',
      appliedAt: '12h ago',
      imageUrl: 'https://i.pravatar.cc/150?u=jordan',
      statusColor: 0xFF64748B,
    ),
  ].obs;

  int get selectedNavIndex => _navService.selectedIndex.value;

  void changeNavIndex(int index) {
    _navService.changeTo(index);
  }
}
