import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';

/// Maps to `ApplicationListItem` (for list) and `ApplicationDetailResponse` (for detail).
///
/// Server statuses: applied, doc_check, doc_failed, ai_processing, ai_passed,
/// under_review, interview, offered, hired, rejected, knockout.
class Candidate {
  final String id;           // application ID
  final String name;         // applicant_name (from detail) or 'Applicant #{id}'
  final String role;         // job_title (from detail) or 'Job #{job_id}'
  final String status;       // server status string
  final int score;           // final_score from CandidateScoreResponse (0 if not scored)
  final String matchText;    // status_label or derived match text
  final String appliedAt;    // formatted created_at
  final String imageUrl;
  final int statusColor;
  final bool isManualOverride;

  // Detail-only fields (null when created from list item)
  final String? email;
  final int? jobId;
  final String? jobTitle;
  final List<Map<String, dynamic>> answers;
  final List<Map<String, dynamic>> documents;
  final Map<String, dynamic>? scoreBreakdown; // full CandidateScoreResponse
  final String? rejectionReason;

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
    this.email,
    this.jobId,
    this.jobTitle,
    this.answers = const [],
    this.documents = const [],
    this.scoreBreakdown,
    this.rejectionReason,
  });

  /// From `ApplicationListItem` — minimal data for list cards.
  factory Candidate.fromListItem(Map<String, dynamic> json) {
    final status = (json['status'] as String? ?? 'applied').toLowerCase();
    return Candidate(
      id: (json['id'] ?? 0).toString(),
      name: json['applicant_name'] as String? ?? 'Applicant #${json['id']}',
      role: json['status_label'] ?? status.toUpperCase(),
      status: status,
      score: 0,
      matchText: json['status_label'] ?? status,
      appliedAt: _formatDate(json['created_at'] as String?),
      imageUrl: '',
      statusColor: _statusColor(status).toARGB32(),
      jobId: json['job_id'] as int?,
    );
  }

  /// From `ApplicationDetailResponse` — full data for detail view.
  factory Candidate.fromDetail(Map<String, dynamic> json) {
    final status = (json['status'] as String? ?? 'applied').toLowerCase();
    final scoreJson = json['score'] as Map<String, dynamic>?;
    final finalScore = scoreJson != null
        ? ((scoreJson['final_score'] as num?) ?? 0).round()
        : 0;
    final matchText = _matchTextFromScore(finalScore, scoreJson);

    return Candidate(
      id: (json['id'] ?? 0).toString(),
      name: json['applicant_name'] as String? ?? 'Unknown',
      role: json['job_title'] as String? ?? 'Unknown Job',
      status: status,
      score: finalScore,
      matchText: matchText,
      appliedAt: _formatDate(json['created_at']?.toString()),
      imageUrl: '',
      statusColor: _statusColor(status).toARGB32(),
      email: json['applicant_email'] as String?,
      jobId: json['job_id'] as int?,
      jobTitle: json['job_title'] as String?,
      answers: _parseList(json['answers']),
      documents: _parseList(json['documents']),
      scoreBreakdown: scoreJson,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Legacy fromJson (keeps backward compatibility).
  factory Candidate.fromJson(Map<String, dynamic> json) {
    // Detect if it's a detail response
    if (json.containsKey('applicant_name') || json.containsKey('job_title')) {
      return Candidate.fromDetail(json);
    }
    return Candidate.fromListItem(json);
  }

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
    String? email,
    int? jobId,
    String? jobTitle,
    List<Map<String, dynamic>>? answers,
    List<Map<String, dynamic>>? documents,
    Map<String, dynamic>? scoreBreakdown,
    String? rejectionReason,
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
        email: email ?? this.email,
        jobId: jobId ?? this.jobId,
        jobTitle: jobTitle ?? this.jobTitle,
        answers: answers ?? this.answers,
        documents: documents ?? this.documents,
        scoreBreakdown: scoreBreakdown ?? this.scoreBreakdown,
        rejectionReason: rejectionReason ?? this.rejectionReason,
      );

  // ── Helpers ──────────────────────────────────────────────────────────

  static Color _statusColor(String status) {
    switch (status) {
      case 'hired':
      case 'ai_passed':
      case 'offered':
        return AppColors.success;
      case 'interview':
      case 'under_review':
        return AppColors.info;
      case 'applied':
      case 'doc_check':
      case 'ai_processing':
        return AppColors.warning;
      case 'rejected':
      case 'doc_failed':
      case 'knockout':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  static String _matchTextFromScore(int score, Map<String, dynamic>? scoreJson) {
    if (scoreJson == null || score == 0) return 'Pending Screening';
    if (score >= 90) return 'Top 5% Match';
    if (score >= 80) return 'Strong Match';
    if (score >= 70) return 'Good Fit';
    if (score >= 60) return 'Possible Fit';
    return 'Low Match';
  }

  static List<Map<String, dynamic>> _parseList(dynamic raw) {
    if (raw is List) return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return [];
  }
}
