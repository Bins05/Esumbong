/// Allowed incident categories — MUST match the DB check constraint
/// incidents_category_check exactly.
const List<String> incidentCategories = [
  'Noise Disturbance',
  'Illegal Dumping',
  'Public Safety',
  'Infrastructure Damage',
  'Emergency',
];

/// Allowed puroks in Barangay Palatiw — adjust as needed.
/// TODO: Confirm the official purok list with the barangay.
const List<String> palatiwPuroks = [
  'Purok 1',
  'Purok 2',
  'Purok 3',
  'Purok 4',
  'Purok 5',
];

/// Validation limits — MUST match Postgres check constraints.
const int titleMinLength = 5;
const int titleMaxLength = 120;
const int descriptionMinLength = 20;
const int descriptionMaxLength = 3000;

/// Bounding box for Barangay Palatiw, Pasig City (approximate).
const double palatiwLatMin = 14.55;
const double palatiwLatMax = 14.60;
const double palatiwLngMin = 121.07;
const double palatiwLngMax = 121.12;
