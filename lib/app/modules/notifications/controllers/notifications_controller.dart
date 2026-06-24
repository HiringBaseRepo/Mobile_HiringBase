import 'package:get/get.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'package:uifrontendmobile/app/services/notification_service.dart';
import '../../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      notifications.clear();
    }
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final response = await Get.find<NotificationService>().listNotifications(
        unreadOnly: false,
        page: 1,
        limit: 50,
      );

      if (response.statusCode == 200 && response.body != null && response.body?['success'] == true) {
        final List<dynamic> dataList = response.body?['data']?['data'] ?? [];
        final parsed = dataList.map((x) => NotificationModel.fromJson(x)).toList();
        notifications.assignAll(parsed);
      } else {
        errorMessage.value = response.body?['message'] ?? 'Gagal memuat notifikasi';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    
    final n = notifications[index];
    if (n.isRead) {
      _navigateForNotification(n.type);
      return;
    }

    final notifId = int.tryParse(id);
    if (notifId == null) return;

    try {
      final response = await Get.find<NotificationService>().markRead(notifId);
      if (response.statusCode == 200 && response.body != null && response.body?['success'] == true) {
        notifications[index] = NotificationModel(
          id: n.id,
          title: n.title,
          body: n.body,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
        );
        _navigateForNotification(n.type);
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Gagal menandai notifikasi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses permintaan: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final unreadCount = notifications.where((n) => !n.isRead).length;
    if (unreadCount == 0) return;

    try {
      final response = await Get.find<NotificationService>().markAllRead();
      if (response.statusCode == 200 && response.body != null && response.body?['success'] == true) {
        for (var i = 0; i < notifications.length; i++) {
          final n = notifications[i];
          if (!n.isRead) {
            notifications[i] = NotificationModel(
              id: n.id,
              title: n.title,
              body: n.body,
              type: n.type,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
        }
        Get.snackbar('Success', 'Semua notifikasi ditandai sebagai terbaca');
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Gagal menandai semua notifikasi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses permintaan: $e');
    }
  }

  void _navigateForNotification(String type) {
    if (type == 'interview' || type == 'interview_scheduled') {
      Get.toNamed(Routes.SELECTION);
    } else if (type == 'new_application') {
      Get.toNamed(Routes.CANDIDATES);
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
