import 'dart:async';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/utils/simple_cache.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class CandidatesController extends GetxController {
  final _navService = Get.find<NavigationService>();
  final _appService = Get.find<ApplicationService>();

  // ── State ──────────────────────────────────────────────────────────
  final candidates = <Candidate>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final int limit = 20;

  final _cache = SimpleCache<Map<String, dynamic>>(ttl: const Duration(minutes: 2));

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

  Timer? _searchDebounce;

  // ── Batch Selection State ──────────────────────────────────────────
  final selectedIds = <String>{}.obs;
  final isSelectionMode = false.obs;
  final isBatchRunning = false.obs;

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

  final jobId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is int) {
        jobId.value = Get.arguments as int;
      } else if (Get.arguments is String) {
        jobId.value = int.tryParse(Get.arguments as String);
      }
    }
    fetchCandidates();
  }

  Future<void> fetchCandidates({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      _cache.invalidate();
    }

    if (!hasMore.value) return;

    final isDefaultState = searchQuery.value.isEmpty && activeFilter.value == 'all';
    if (!refresh && currentPage.value == 1 && isDefaultState && _cache.isValid) {
      final cached = _cache.data!;
      candidates.assignAll(cached['items'] as List<Candidate>);
      hasMore.value = cached['hasMore'] as bool;
      currentPage.value = 2;
      return;
    }

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = '';

      final response = await _appService.listApplications(
        jobId: jobId.value,
        statusFilter: activeFilter.value == 'all' ? null : activeFilter.value,
        q: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: currentPage.value,
        limit: limit,
      );

      if (response.statusCode != 200 || response.body == null) {
        errorMessage.value = response.body?['message']?.toString() ??
            'Failed to load candidates.';
        return;
      }

      final outer = response.body!['data'];
      List<dynamic> items = [];
      int total = 0;
      if (outer is Map) {
        final raw = outer['data'] ?? outer['items'] ?? [];
        items = raw is List ? raw : [];
        total = (outer['total'] as int?) ?? 0;
      }

      final newCandidates = items.map((j) => Candidate.fromListItem(j as Map<String, dynamic>)).toList();

      if (currentPage.value == 1) {
        candidates.assignAll(newCandidates);
        if (isDefaultState) {
          _cache.set({
            'items': List<Candidate>.from(newCandidates),
            'hasMore': hasMore.value,
          });
        }
      } else {
        candidates.addAll(newCandidates);
      }

      hasMore.value = candidates.length < total;
      if (newCandidates.isNotEmpty) {
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your internet.';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;
    await fetchCandidates();
  }

  void changeFilter(String filter) {
    activeFilter.value = filter;
    fetchCandidates(refresh: true);
  }

  void onSearchChanged(String q) {
    searchQuery.value = q;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      fetchCandidates(refresh: true);
    });
  }

  /// Updates status locally (called from detail after successful API update).
  void updateCandidateStatus(String id, String newStatus) {
    final idx = candidates.indexWhere((c) => c.id == id);
    if (idx != -1) {
      candidates[idx] = candidates[idx].copyWith(status: newStatus);
    }
  }

  // ── Batch Selection Methods ───────────────────────────────────────

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedIds.clear();
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  bool isSelected(String id) => selectedIds.contains(id);

  void selectAll() {
    final allIds = filteredCandidates.map((c) => c.id).toSet();
    if (selectedIds.containsAll(allIds)) {
      selectedIds.clear();
    } else {
      selectedIds.assignAll(allIds);
    }
  }

  void clearSelection() {
    selectedIds.clear();
  }

  bool get allSelected =>
      filteredCandidates.isNotEmpty &&
      selectedIds.containsAll(filteredCandidates.map((c) => c.id));

  /// Submit batch screening for all selected candidates.
  Future<void> runBatchScreening() async {
    if (selectedIds.isEmpty || isBatchRunning.value) return;

    isBatchRunning.value = true;
    try {
      final response = await _appService.runBatchScreening(selectedIds.toList());

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body!['data'];
        final queued = data?['queued'] ?? 0;
        final total = data?['total'] ?? 0;
        final duplicates = data?['duplicates'] ?? 0;
        final quotaBlocked = data?['quota_blocked'] ?? 0;

        String message = '$queued of $total screening(s) queued.';
        if (duplicates > 0) message += ' $duplicates duplicate(s) skipped.';
        if (quotaBlocked > 0) message += ' $quotaBlocked blocked by quota.';

        Get.snackbar('Batch Screening', message);
      } else {
        Get.snackbar('Error', response.body?['message']?.toString() ?? 'Batch screening failed.');
      }

      selectedIds.clear();
      isSelectionMode.value = false;
      fetchCandidates(refresh: true);
    } catch (e) {
      Get.snackbar('Error', 'Connection error. Please check your internet.');
    } finally {
      isBatchRunning.value = false;
    }
  }

  void changeNavIndex(int index) {
    _navService.changeTo(index);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
