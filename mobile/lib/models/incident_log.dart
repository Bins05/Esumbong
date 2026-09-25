import 'enums.dart';

class IncidentLog {
  const IncidentLog({
    required this.id,
    required this.incidentId,
    this.actorId,
    required this.action,
    this.fromStatus,
    this.toStatus,
    this.note,
    required this.isPublic,
    required this.createdAt,
  });

  final String id;
  final String incidentId;
  final String? actorId;
  final String action;
  final IncidentStatus? fromStatus;
  final IncidentStatus? toStatus;
  final String? note;
  final bool isPublic;
  final DateTime createdAt;

  factory IncidentLog.fromMap(Map<String, dynamic> map) {
    return IncidentLog(
      id: map['id'] as String,
      incidentId: map['incident_id'] as String,
      actorId: map['actor_id'] as String?,
      action: map['action'] as String,
      fromStatus: _parseStatus(map['from_status']),
      toStatus: _parseStatus(map['to_status']),
      note: map['note'] as String?,
      isPublic: map['is_public'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static IncidentStatus? _parseStatus(Object? value) {
    final status = value as String?;
    return status == null ? null : IncidentStatus.fromString(status);
  }
}
