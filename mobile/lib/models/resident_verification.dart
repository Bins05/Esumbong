import 'enums.dart';

class ResidentVerification {
  const ResidentVerification({
    required this.id,
    required this.userId,
    required this.barangayId,
    required this.idNumber,
    required this.address,
    required this.documentPath,
    required this.status,
    this.reviewNote,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String barangayId;
  final String idNumber;
  final String address;
  final String documentPath;
  final VerificationStatus status;
  final String? reviewNote;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;

  factory ResidentVerification.fromMap(Map<String, dynamic> map) {
    return ResidentVerification(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      barangayId: map['barangay_id'] as String,
      idNumber: map['id_number'] as String,
      address: map['address'] as String,
      documentPath: map['document_path'] as String,
      status: VerificationStatus.fromString(map['status'] as String),
      reviewNote: map['review_note'] as String?,
      reviewedBy: map['reviewed_by'] as String?,
      reviewedAt: _parseDate(map['reviewed_at']),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static DateTime? _parseDate(Object? value) {
    final date = value as String?;
    return date == null ? null : DateTime.parse(date);
  }
}
