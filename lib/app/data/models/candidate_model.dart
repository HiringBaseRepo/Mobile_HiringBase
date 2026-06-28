import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/data/models/candidate_score.dart';

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
  final CandidateScore? scoreData; // typed score object
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
    this.scoreData,
    this.rejectionReason,
  });

  /// From `ApplicationListItem` — minimal data for list cards.
  factory Candidate.fromListItem(Map<String, dynamic> json) {
    final status = (json['status'] as String? ?? 'applied').toLowerCase();
    final score = json['score'] as int? ?? 0;
    return Candidate(
      id: (json['id'] ?? 0).toString(),
      name: json['applicant_name'] as String? ?? 'Applicant #${json['id']}',
      role: json['status_label'] ?? status.toUpperCase(),
      status: status,
      score: score,
      matchText: _matchTextFromScore(score, null),
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
    final scoreData = scoreJson != null
        ? CandidateScore.fromJson(scoreJson)
        : null;
    final finalScore = scoreData?.finalScore.round() ?? 0;
    final matchText = _matchTextFromScore(finalScore, scoreData);

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
      isManualOverride: scoreData?.isManualOverride ?? false,
      scoreData: scoreData,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Legacy fromJson (keeps backward compatibility).
  factory Candidate.fromJson(Map<String, dynamic> json) {
    // Detect if it's a detail response
    if (json.containsKey('job_title') || json.containsKey('answers')) {
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
    CandidateScore? scoreData,
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
        scoreData: scoreData ?? this.scoreData,
        rejectionReason: rejectionReason ?? this.rejectionReason,
      );

  // ── Helpers ──────────────────────────────────────────────────────────

  String get statusIndonesian {
    switch (status) {
      case 'applied':
        return 'Baru Terdaftar';
      case 'doc_check':
        return 'Verifikasi Dokumen';
      case 'doc_failed':
        return 'Verifikasi Dokumen Gagal';
      case 'ai_processing':
        return 'Proses AI Screening';
      case 'ai_passed':
        return 'Lolos AI Screening';
      case 'under_review':
        return 'Sedang Ditinjau';
      case 'interview':
        return 'Wawancara';
      case 'offered':
        return 'Ditawarkan Kontrak';
      case 'hired':
        return 'Diterima Kerja';
      case 'rejected':
        return 'Ditolak';
      case 'knockout':
        return 'Gugur Kualifikasi';
      default:
        return status;
    }
  }

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
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  static String _matchTextFromScore(int score, CandidateScore? scoreData) {
    if (score == 0) return 'Menunggu Screening';
    if (score >= 90) return 'Sangat Cocok (Top 5%)';
    if (score >= 80) return 'Sangat Cocok';
    if (score >= 70) return 'Cocok';
    if (score >= 60) return 'Cukup Cocok';
    return 'Kurang Cocok';
  }

  static List<Map<String, dynamic>> _parseList(dynamic raw) {
    if (raw is List) return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return [];
  }
}
