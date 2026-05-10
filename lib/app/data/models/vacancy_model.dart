class Vacancy {
  final String id;
  final String title;
  final String department;
  final String location;
  final String type;
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> docs;
  final String status; // 'draft' | 'published' | 'closed'
  final int applicantCount;
  final String postedAt;

  const Vacancy({
    required this.id,
    required this.title,
    required this.department,
    required this.location,
    required this.type,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.docs,
    this.status = 'published',
    this.applicantCount = 0,
    this.postedAt = '',
  });

  factory Vacancy.fromJson(Map<String, dynamic> json) => Vacancy(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        department: json['department'] ?? '',
        location: json['location'] ?? '',
        type: json['type'] ?? '',
        salary: json['salary'] ?? '',
        description: json['description'] ?? '',
        requirements: List<String>.from(json['requirements'] ?? []),
        docs: List<String>.from(json['docs'] ?? []),
        status: json['status'] ?? 'published',
        applicantCount: json['applicantCount'] ?? 0,
        postedAt: json['postedAt'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'department': department,
        'location': location,
        'type': type,
        'salary': salary,
        'description': description,
        'requirements': requirements,
        'docs': docs,
        'status': status,
        'applicantCount': applicantCount,
        'postedAt': postedAt,
      };
}
