enum UserRole {
  resident,
  tanod,
  official,
  admin;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (item) => item.toDb() == value,
      orElse: () => throw ArgumentError('Unknown user role: $value'),
    );
  }

  String toDb() => name;
}

enum VerificationStatus {
  pending,
  verified,
  rejected;

  static VerificationStatus fromString(String value) {
    return VerificationStatus.values.firstWhere(
      (item) => item.toDb() == value,
      orElse: () => throw ArgumentError('Unknown verification status: $value'),
    );
  }

  String toDb() => name;
}

enum IncidentStatus {
  pending,
  underReview,
  inProgress,
  resolved,
  dismissed;

  static IncidentStatus fromString(String value) {
    return IncidentStatus.values.firstWhere(
      (item) => item.toDb() == value,
      orElse: () => throw ArgumentError('Unknown incident status: $value'),
    );
  }

  String toDb() {
    switch (this) {
      case IncidentStatus.pending:
        return 'pending';
      case IncidentStatus.underReview:
        return 'under_review';
      case IncidentStatus.inProgress:
        return 'in_progress';
      case IncidentStatus.resolved:
        return 'resolved';
      case IncidentStatus.dismissed:
        return 'dismissed';
    }
  }
}

enum IncidentPriority {
  low,
  normal,
  high,
  critical;

  static IncidentPriority fromString(String value) {
    return IncidentPriority.values.firstWhere(
      (item) => item.toDb() == value,
      orElse: () => throw ArgumentError('Unknown incident priority: $value'),
    );
  }

  String toDb() => name;
}

enum NotificationType {
  statusUpdate,
  newMessage,
  assignment,
  broadcast;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (item) => item.toDb() == value,
      orElse: () => throw ArgumentError('Unknown notification type: $value'),
    );
  }

  String toDb() {
    switch (this) {
      case NotificationType.statusUpdate:
        return 'status_update';
      case NotificationType.newMessage:
        return 'new_message';
      case NotificationType.assignment:
        return 'assignment';
      case NotificationType.broadcast:
        return 'broadcast';
    }
  }
}
