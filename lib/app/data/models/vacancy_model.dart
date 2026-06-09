/// Represents a job vacancy item returned from the server's `JobListItem` schema.
///
/// Used for displaying jobs in the list view and passing to the detail page.
/// Server fields: id (int), title, department, employment_type (enum), status (enum),
/// location, apply_code, published_at, created_at, status_label, employment_type_label.
class Vacancy {
  final String id;           // parsed from server int
  final String title;
  final String department;
  final String location;
  final String employmentType; // raw server enum: 'full_time' | 'part_time' | 'contract' | 'freelance' | 'intern'
  final String employmentTypeLabel; // human-readable from server
  final String status;        // 'draft' | 'scheduled' | 'published' | 'closed' | 'private'
  final String statusLabel;   // human-readable from server
  final String? applyCode;
  final String? publishedAt;
  final String createdAt;

  // Detail-level fields (populated from JobDetailResponse, optional on list)
  final String description;
  final String? responsibilities;
  final String? benefits;
  final int? salaryMin;
  final int? salaryMax;
  final int applicantCount;

  const Vacancy({
    required this.id,
    required this.title,
    this.department = '',
    this.location = '',
    this.employmentType = 'full_time',
    this.employmentTypeLabel = 'Full Time',
    this.status = 'draft',
    this.statusLabel = 'Draft',
    this.applyCode,
    this.publishedAt,
    this.createdAt = '',
    this.description = '',
    this.responsibilities,
    this.benefits,
    this.salaryMin,
    this.salaryMax,
    this.applicantCount = 0,
  });

  /// Deserialises from the server's `JobListItem` JSON response.
  factory Vacancy.fromJson(Map<String, dynamic> json) => Vacancy(
        id: (json['id'] ?? 0).toString(),
        title: json['title'] ?? '',
        department: json['department'] ?? '',
        location: json['location'] ?? '',
        employmentType: json['employment_type'] ?? 'full_time',
        employmentTypeLabel: json['employment_type_label'] ?? _labelFromType(json['employment_type'] ?? ''),
        status: json['status'] ?? 'draft',
        statusLabel: json['status_label'] ?? _labelFromStatus(json['status'] ?? ''),
        applyCode: json['apply_code'] as String?,
        publishedAt: json['published_at'] as String?,
        createdAt: json['created_at'] ?? '',
        description: json['description'] ?? '',
        responsibilities: json['responsibilities'] as String?,
        benefits: json['benefits'] as String?,
        salaryMin: json['salary_min'] as int?,
        salaryMax: json['salary_max'] as int?,
        applicantCount: json['applicant_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'department': department,
        'location': location,
        'employment_type': employmentType,
        'status': status,
        'apply_code': applyCode,
        'published_at': publishedAt,
        'created_at': createdAt,
        'description': description,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
      };

  Vacancy copyWith({
    String? id,
    String? title,
    String? department,
    String? location,
    String? employmentType,
    String? employmentTypeLabel,
    String? status,
    String? statusLabel,
    String? applyCode,
    String? publishedAt,
    String? createdAt,
    String? description,
    String? responsibilities,
    String? benefits,
    int? salaryMin,
    int? salaryMax,
    int? applicantCount,
  }) =>
      Vacancy(
        id: id ?? this.id,
        title: title ?? this.title,
        department: department ?? this.department,
        location: location ?? this.location,
        employmentType: employmentType ?? this.employmentType,
        employmentTypeLabel: employmentTypeLabel ?? this.employmentTypeLabel,
        status: status ?? this.status,
        statusLabel: statusLabel ?? this.statusLabel,
        applyCode: applyCode ?? this.applyCode,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        responsibilities: responsibilities ?? this.responsibilities,
        benefits: benefits ?? this.benefits,
        salaryMin: salaryMin ?? this.salaryMin,
        salaryMax: salaryMax ?? this.salaryMax,
        applicantCount: applicantCount ?? this.applicantCount,
      );

  /// Returns a display-friendly salary string, e.g. "Rp 5.000.000 - Rp 8.000.000".
  String get salaryDisplay {
    if (salaryMin == null && salaryMax == null) return 'Negotiable';
    final min = salaryMin != null ? _formatSalary(salaryMin!) : '';
    final max = salaryMax != null ? _formatSalary(salaryMax!) : '';
    if (min.isNotEmpty && max.isNotEmpty) return 'Rp $min - Rp $max';
    if (min.isNotEmpty) return 'From Rp $min';
    return 'Up to Rp $max';
  }

  /// Returns a short display date e.g. "08 Jun 2026" from publishedAt or createdAt.
  String get postedAt {
    final raw = publishedAt ?? createdAt;
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day.toString().padLeft(2,'0')} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      // If parsing fails, return trimmed raw value
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  static String _formatSalary(int value) =>
      value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');

  static String _labelFromStatus(String s) {
    switch (s) {
      case 'published': return 'Published';
      case 'closed':    return 'Closed';
      case 'scheduled': return 'Scheduled';
      case 'private':   return 'Private';
      default:          return 'Draft';
    }
  }

  static String _labelFromType(String t) {
    switch (t) {
      case 'full_time':  return 'Full Time';
      case 'part_time':  return 'Part Time';
      case 'contract':   return 'Contract';
      case 'freelance':  return 'Freelance';
      case 'intern':     return 'Internship';
      default:           return t;
    }
  }
}
