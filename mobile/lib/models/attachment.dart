class Attachment {
  const Attachment({
    required this.id,
    required this.incidentId,
    required this.uploadedBy,
    required this.storagePath,
    required this.fileName,
    required this.mediaType,
    required this.sizeBytes,
    required this.createdAt,
  });

  final String id;
  final String incidentId;
  final String uploadedBy;
  final String storagePath;
  final String fileName;
  final String mediaType;
  final int sizeBytes;
  final DateTime createdAt;

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'] as String,
      incidentId: map['incident_id'] as String,
      uploadedBy: map['uploaded_by'] as String,
      storagePath: map['storage_path'] as String,
      fileName: map['file_name'] as String,
      mediaType: map['media_type'] as String,
      sizeBytes: (map['size_bytes'] as num).toInt(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
