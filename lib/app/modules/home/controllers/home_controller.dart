import 'package:get/get.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';


class HomeController extends GetxController {
  final stats = [
    {'title': 'Total Applicants', 'value': '260', 'icon': 0xe491, 'color': 0xFF3B82F6}, // person_outline
    {'title': 'Active Listings', 'value': '8', 'icon': 0xe11e, 'color': 0xFF8B5CF6}, // work_outline
    {'title': 'Passed Screen', 'value': '67', 'icon': 0xe156, 'color': 0xFF10B981}, // check_circle_outline
  ].obs;

  final candidates = [
    {
      'name': 'Alex Rivera',
      'role': 'Senior Dev',
      'status': 'Interview',
      'score': 92,
      'image': 'https://i.pravatar.cc/150?u=alex',
    },
    {
      'name': 'Sarah Chen',
      'role': 'UI Designer',
      'status': 'Reviewed',
      'score': 85,
      'image': 'https://i.pravatar.cc/150?u=sarah',
    },
    {
      'name': 'Jordan Lee',
      'role': 'Product Manager',
      'status': 'Reviewed',
      'score': 78,
      'image': 'https://i.pravatar.cc/150?u=jordan',
    },
  ].obs;

  final selectedNavIndex = 0.obs;

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
    if (index == 1) {
      Get.toNamed('/jobs');
    }
  }
}
