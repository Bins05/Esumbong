import '../core/constants.dart';

class IncidentValidators {
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    final v = value.trim();
    if (v.length < titleMinLength) {
      return 'Title must be at least $titleMinLength characters';
    }
    if (v.length > titleMaxLength) {
      return 'Title must be at most $titleMaxLength characters';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    final v = value.trim();
    if (v.length < descriptionMinLength) {
      return 'Description must be at least $descriptionMinLength characters';
    }
    if (v.length > descriptionMaxLength) {
      return 'Description must be at most $descriptionMaxLength characters';
    }
    return null;
  }

  static String? category(String? value) {
    if (value == null || value.isEmpty) return 'Category is required';
    if (!incidentCategories.contains(value)) return 'Invalid category';
    return null;
  }

  static String? purok(String? value) {
    if (value == null || value.trim().isEmpty) return 'Purok is required';
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) return 'Address is required';
    return null;
  }

  static String? latitude(double? value) {
    if (value == null) return 'Location is required';
    if (value < -90 || value > 90) return 'Invalid latitude';
    return null;
  }

  static String? longitude(double? value) {
    if (value == null) return 'Location is required';
    if (value < -180 || value > 180) return 'Invalid longitude';
    return null;
  }
}
