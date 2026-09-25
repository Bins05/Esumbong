import 'enums.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.barangayId,
    required this.role,
    required this.fullName,
    this.phone,
    this.purok,
    required this.isVerified,
    required this.verificationStatus,
  });

  final String id;
  final String barangayId;
  final UserRole role;
  final String fullName;
  final String? phone;
  final String? purok;
  final bool isVerified;
  final VerificationStatus verificationStatus;

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      barangayId: map['barangay_id'] as String,
      role: UserRole.fromString(map['role'] as String),
      fullName: map['full_name'] as String,
      phone: map['phone'] as String?,
      purok: map['purok'] as String?,
      isVerified: map['is_verified'] as bool,
      verificationStatus: VerificationStatus.fromString(
        map['verification_status'] as String,
      ),
    );
  }

  bool get isStaff => role == UserRole.tanod || role == UserRole.official || role == UserRole.admin;

  bool get canSubmitReports =>
      role == UserRole.resident &&
      isVerified &&
      verificationStatus == VerificationStatus.verified;
}
