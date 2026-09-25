class Barangay {
  const Barangay({
    required this.id,
    required this.name,
    required this.municipality,
    required this.province,
  });

  final String id;
  final String name;
  final String municipality;
  final String province;

  factory Barangay.fromMap(Map<String, dynamic> map) {
    return Barangay(
      id: map['id'] as String,
      name: map['name'] as String,
      municipality: map['municipality'] as String,
      province: map['province'] as String,
    );
  }
}
