class Interview {
  final String candidateName;
  final String role;
  final String date;
  final String time;
  final String platform;
  final String link;
  final String status;

  const Interview({
    required this.candidateName,
    required this.role,
    required this.date,
    required this.time,
    required this.platform,
    required this.link,
    required this.status,
  });

  factory Interview.empty() {
    return const Interview(
      candidateName: '',
      role: '',
      date: '',
      time: '',
      platform: '',
      link: '',
      status: '',
    );
  }

  factory Interview.fromCandidate(dynamic candidate) {
    return Interview(
      candidateName: candidate?.name ?? '',
      role: candidate?.role ?? '',
      date: '',
      time: '',
      platform: '',
      link: '',
      status: '',
    );
  }

  Interview copyWith({
    String? candidateName,
    String? role,
    String? date,
    String? time,
    String? platform,
    String? link,
    String? status,
  }) {
    return Interview(
      candidateName: candidateName ?? this.candidateName,
      role: role ?? this.role,
      date: date ?? this.date,
      time: time ?? this.time,
      platform: platform ?? this.platform,
      link: link ?? this.link,
      status: status ?? this.status,
    );
  }
}
