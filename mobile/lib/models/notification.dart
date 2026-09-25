import 'enums.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    this.incidentId,
    required this.type,
    required this.title,
    required this.body,
    this.readAt,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? incidentId;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      incidentId: map['incident_id'] as String?,
      type: NotificationType.fromString(map['type'] as String),
      title: map['title'] as String,
      body: map['body'] as String,
      readAt: _parseDate(map['read_at']),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static DateTime? _parseDate(Object? value) {
    final date = value as String?;
    return date == null ? null : DateTime.parse(date);
  }
}
