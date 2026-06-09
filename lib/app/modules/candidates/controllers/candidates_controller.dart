import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class CandidatesController extends GetxController {
  final _navService = Get.find<NavigationService>();
  final _appService = Get.find<ApplicationService>();

  // ── State ──────────────────────────────────────────────────────────
  final candidates = <Candidate>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  /// Active status filter tab ('all' | server status string).
  final activeFilter = 'all'.obs;

  final statusTabs = const [
    'all',
    'applied',
    'under_review',
    'interview',
    'hired',
    'rejected',
  ];

  // ── Getters ────────────────────────────────────────────────────────
  int get selectedNavIndex => _navService.selectedIndex.value;

  List<Candidate> get filteredCandidates {
    if (searchQuery.value.isEmpty) return candidates;
    final q = searchQuery.value.toLowerCase();
    return candidates.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.role.toLowerCase().contains(q) ||
          c.status.contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCandidates();
  }

  Future<void> fetchCandidates({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _appService.listApplications(
        statusFilter: activeFilter.value == 'all' ? null : activeFilter.value,
        q: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (response.statusCode != 200 || response.body == null) {
        errorMessage.value = response.body?['message']?.toString() ??
            'Failed to load candidates.';
        return;
      }

      final outer = response.body!['data'];
      List<dynamic> items = [];
      if (outer is Map) {
        final raw = outer['data'] ?? outer['items'] ?? [];
        items = raw is List ? raw : [];
      }

      candidates.assignAll(
        items.map((j) => Candidate.fromListItem(j as Map<String, dynamic>)),
      );
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your internet.';
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    activeFilter.value = filter;
    fetchCandidates(refresh: true);
  }

  void onSearchChanged(String q) {
    searchQuery.value = q;
    fetchCandidates(refresh: true);
  }

  /// Updates status locally (called from detail after successful API update).
  void updateCandidateStatus(String id, String newStatus) {
    final idx = candidates.indexWhere((c) => c.id == id);
    if (idx != -1) {
      candidates[idx] = candidates[idx].copyWith(status: newStatus);
    }
  }

  void changeNavIndex(int index) {
    _navService.changeTo(index);
  }
}
