class Candidate {
  final String id;
  final String name;
  final String role;
  final String status;
  final int score;
  final String matchText;
  final String appliedAt;
  final String imageUrl;
  final int statusColor;
  final bool isManualOverride;

  const Candidate({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.score,
    required this.matchText,
    required this.appliedAt,
    required this.imageUrl,
    required this.statusColor,
    this.isManualOverride = false,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        role: json['role'] ?? '',
        status: json['status'] ?? '',
        score: json['score'] ?? 0,
        matchText: json['matchText'] ?? '',
        appliedAt: json['appliedAt'] ?? '',
        imageUrl: json['image'] ?? '',
        statusColor: json['statusColor'] ?? 0xFF64748B,
        isManualOverride: json['isManualOverride'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'status': status,
        'score': score,
        'matchText': matchText,
        'appliedAt': appliedAt,
        'image': imageUrl,
        'statusColor': statusColor,
        'isManualOverride': isManualOverride,
      };

  Candidate copyWith({
    String? id,
    String? name,
    String? role,
    String? status,
    int? score,
    String? matchText,
    String? appliedAt,
    String? imageUrl,
    int? statusColor,
    bool? isManualOverride,
  }) =>
      Candidate(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        status: status ?? this.status,
        score: score ?? this.score,
        matchText: matchText ?? this.matchText,
        appliedAt: appliedAt ?? this.appliedAt,
        imageUrl: imageUrl ?? this.imageUrl,
        statusColor: statusColor ?? this.statusColor,
        isManualOverride: isManualOverride ?? this.isManualOverride,
      );
}
