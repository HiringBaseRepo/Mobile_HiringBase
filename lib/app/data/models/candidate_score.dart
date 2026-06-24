/// Typed model for the `score` object returned by
/// `GET /applications/{id}` (CandidateScoreResponse).
///
/// Backend schema: `app/features/applications/schemas/schema.py`
class CandidateScore {
  final double skillMatchScore;
  final double experienceScore;
  final double educationScore;
  final double portfolioScore;
  final double softSkillScore;
  final double administrativeScore;
  final double finalScore;
  final String? explanation;
  final List<RedFlag>? redFlags;
  final String? riskLevel;
  final ScoringBreakdown? scoringBreakdown;
  final bool isManualOverride;

  const CandidateScore({
    required this.skillMatchScore,
    required this.experienceScore,
    required this.educationScore,
    required this.portfolioScore,
    required this.softSkillScore,
    required this.administrativeScore,
    required this.finalScore,
    this.explanation,
    this.redFlags,
    this.riskLevel,
    this.scoringBreakdown,
    this.isManualOverride = false,
  });

  factory CandidateScore.fromJson(Map<String, dynamic> json) {
    return CandidateScore(
      skillMatchScore: (json['skill_match_score'] as num?)?.toDouble() ?? 0,
      experienceScore: (json['experience_score'] as num?)?.toDouble() ?? 0,
      educationScore: (json['education_score'] as num?)?.toDouble() ?? 0,
      portfolioScore: (json['portfolio_score'] as num?)?.toDouble() ?? 0,
      softSkillScore: (json['soft_skill_score'] as num?)?.toDouble() ?? 0,
      administrativeScore: (json['administrative_score'] as num?)?.toDouble() ?? 0,
      finalScore: (json['final_score'] as num?)?.toDouble() ?? 0,
      explanation: json['explanation'] as String?,
      redFlags: (json['red_flags'] as List?)
          ?.map((e) => RedFlag.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      riskLevel: json['risk_level'] as String?,
      scoringBreakdown: json['scoring_breakdown'] != null
          ? ScoringBreakdown.fromJson(
              Map<String, dynamic>.from(json['scoring_breakdown'] as Map))
          : null,
      isManualOverride: json['is_manual_override'] == true,
    );
  }

  /// Convenience getters for score components as fractions (0.0–1.0).
  double get skillMatchFraction => (skillMatchScore / 100).clamp(0.0, 1.0);
  double get experienceFraction => (experienceScore / 100).clamp(0.0, 1.0);
  double get educationFraction => (educationScore / 100).clamp(0.0, 1.0);
  double get portfolioFraction => (portfolioScore / 100).clamp(0.0, 1.0);
  double get softSkillFraction => (softSkillScore / 100).clamp(0.0, 1.0);
  double get administrativeFraction => (administrativeScore / 100).clamp(0.0, 1.0);

  /// Display label derived from final score.
  String get matchLabel {
    if (finalScore == 0) return 'Pending Screening';
    if (finalScore >= 90) return 'Top 5% Match';
    if (finalScore >= 80) return 'Strong Match';
    if (finalScore >= 70) return 'Good Fit';
    if (finalScore >= 60) return 'Possible Fit';
    return 'Low Match';
  }
}

/// Risk level enum-like string: `low`, `medium`, `high`.
///
/// Stored as string in the model for simplicity.
class RedFlag {
  final String type;
  final String message;

  const RedFlag({required this.type, required this.message});

  factory RedFlag.fromJson(Map<String, dynamic> json) {
    return RedFlag(
      type: json['type'] as String? ?? 'info',
      message: json['message'] as String? ?? '',
    );
  }
}

/// Deep scoring breakdown from the LLM pipeline.
class ScoringBreakdown {
  final Map<String, ComponentDetail>? components;
  final bool? forceUnderReview;
  final bool? skillGatePassed;
  final String? summary;

  const ScoringBreakdown({
    this.components,
    this.forceUnderReview,
    this.skillGatePassed,
    this.summary,
  });

  factory ScoringBreakdown.fromJson(Map<String, dynamic> json) {
    final rawComponents = json['components'] as Map<String, dynamic>?;
    final components = rawComponents?.map(
      (key, value) => MapEntry(
        key,
        ComponentDetail.fromJson(Map<String, dynamic>.from(value as Map)),
      ),
    );

    final gates = json['gates'] as Map<String, dynamic>?;

    return ScoringBreakdown(
      components: components,
      forceUnderReview: gates?['force_under_review'] as bool?,
      skillGatePassed: gates?['skill_gate_passed'] as bool?,
      summary: json['summary'] as String?,
    );
  }
}

/// Individual scoring dimension detail from the LLM breakdown.
class ComponentDetail {
  final int rating; // 1–5
  final double score;
  final double? confidence;
  final String? reasoning;

  const ComponentDetail({
    required this.rating,
    required this.score,
    this.confidence,
    this.reasoning,
  });

  factory ComponentDetail.fromJson(Map<String, dynamic> json) {
    return ComponentDetail(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble(),
      reasoning: json['reasoning'] as String?,
    );
  }
}
