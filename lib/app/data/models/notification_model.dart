class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'new_application' | 'status_change' | 'interview'
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        body: json['message'] ?? json['body'] ?? '',
        type: json['type'] ?? 'new_application',
        isRead: json['is_read'] ?? json['isRead'] ?? false,
        createdAt: json['created_at'] ?? json['createdAt'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt,
      };
}
