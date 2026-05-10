import 'package:get/get.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import '../../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    
    notifications.assignAll([
      const NotificationModel(
        id: '1',
        title: 'New Application',
        body: 'Sarah Jenkins applied for Senior UI Designer.',
        type: 'new_application',
        isRead: false,
        createdAt: '2 mins ago',
      ),
      const NotificationModel(
        id: '2',
        title: 'Interview Scheduled',
        body: 'Interview with David Miller set for tomorrow at 10:00 AM.',
        type: 'interview',
        isRead: false,
        createdAt: '1 hour ago',
      ),
      const NotificationModel(
        id: '3',
        title: 'Status Updated',
        body: 'Michael Chen status changed to "Technical Test".',
        type: 'status_change',
        isRead: true,
        createdAt: '5 hours ago',
      ),
      const NotificationModel(
        id: '4',
        title: 'New Application',
        body: 'Jessica Wong applied for Backend Engineer.',
        type: 'new_application',
        isRead: true,
        createdAt: '1 day ago',
      ),
    ]);
    
    isLoading.value = false;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final n = notifications[index];
      notifications[index] = NotificationModel(
        id: n.id,
        title: n.title,
        body: n.body,
        type: n.type,
        isRead: true,
        createdAt: n.createdAt,
      );

      // Handle navigation based on type
      if (n.type == 'interview') {
        Get.toNamed(Routes.INTERVIEW_DETAIL);
      } else if (n.type == 'new_application') {
        Get.toNamed(Routes.CANDIDATES);
      }
    }
  }

  void markAllAsRead() {
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
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
