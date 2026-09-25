import 'enums.dart';

class Incident {
  const Incident({
    required this.id,
    required this.reference,
    required this.barangayId,
    this.reporterId,
    required this.submittedBy,
    required this.isAnonymous,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.purok,
    required this.address,
    this.latitude,
    this.longitude,
    this.assignedTo,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String reference;
  final String barangayId;
  final String? reporterId;
  final String submittedBy;
  final bool isAnonymous;
  final String category;
  final String title;
  final String description;
  final IncidentStatus status;
  final IncidentPriority priority;
  final String purok;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? assignedTo;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] as String,
      reference: map['reference'] as String,
      barangayId: map['barangay_id'] as String,
      reporterId: map['reporter_id'] as String?,
      submittedBy: map['submitted_by'] as String,
      isAnonymous: map['is_anonymous'] as bool,
      category: map['category'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: IncidentStatus.fromString(map['status'] as String),
      priority: IncidentPriority.fromString(map['priority'] as String),
      purok: map['purok'] as String,
      address: map['address'] as String,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      assignedTo: map['assigned_to'] as String?,
      resolvedAt: _parseDate(map['resolved_at']),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap({
    required String userId,
    required bool anonymous,
  }) {
    // Anonymous reports must have reporter_id set to null; submitted_by is
    // always the current authenticated user's id.
    return {
      'barangay_id': barangayId,
      'reporter_id': anonymous ? null : userId,
      'submitted_by': userId,
      'is_anonymous': anonymous,
      'category': category,
      'title': title,
      'description': description,
      // RLS does not restrict these fields on insert, so the client must not
      // allow a reporter to self-assign status or priority.
      'status': IncidentStatus.pending.toDb(),
      'priority': IncidentPriority.normal.toDb(),
      'purok': purok,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  bool get hasLocation => latitude != null && longitude != null;

  Incident copyWith({
    String? reference,
    String? category,
    String? title,
    String? description,
    IncidentStatus? status,
    IncidentPriority? priority,
    String? purok,
    String? address,
    double? latitude,
    double? longitude,
    String? assignedTo,
    DateTime? resolvedAt,
    DateTime? updatedAt,
  }) {
    return Incident(
      id: id,
      reference: reference ?? this.reference,
      barangayId: barangayId,
      reporterId: reporterId,
      submittedBy: submittedBy,
      isAnonymous: isAnonymous,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      purok: purok ?? this.purok,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      assignedTo: assignedTo ?? this.assignedTo,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(Object? value) {
    final date = value as String?;
    return date == null ? null : DateTime.parse(date);
  }
}
