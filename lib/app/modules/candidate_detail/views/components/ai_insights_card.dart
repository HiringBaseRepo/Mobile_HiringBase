import 'package:flutter/material.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/values/app_text_styles.dart';
import 'package:uifrontendmobile/app/data/models/candidate_score.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/views/components/warning_card.dart';

class AiInsightsCard extends StatelessWidget {
  final CandidateScore? scoreData;

  const AiInsightsCard({
    super.key,
    required this.scoreData,
  });

  @override
  Widget build(BuildContext context) {
    final score = scoreData?.finalScore.round() ?? 0;
    final isManualOverride = scoreData?.isManualOverride ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI INSIGHTS',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              if (scoreData?.riskLevel != null) ...[
                const SizedBox(width: 12),
                _RiskBadge(riskLevel: scoreData!.riskLevel!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Score header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Match Score',
                        style: AppTextStyles.bodyS,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$score',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 48,
                              color: _scoreColor(score),
                            ),
                          ),
                          Text(
                            '/100',
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (isManualOverride) _buildOverrideBadge(),
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 8,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: score / 100,
                              strokeWidth: 8,
                              color: _scoreColor(score),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // ── Dimension scores ──
              ..._buildScoreComponents(),
              // ── Explanation (LLM-generated) ──
              if (scoreData?.explanation != null && scoreData!.explanation!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Divider(height: 1, color: AppColors.surface),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'AI ANALYSIS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  scoreData!.explanation!,
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
              // ── Scoring Breakdown: Summary ──
              if (scoreData?.scoringBreakdown?.summary != null &&
                  scoreData!.scoringBreakdown!.summary!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    scoreData!.scoringBreakdown!.summary!,
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              // ── Per-component reasoning ──
              if (scoreData?.scoringBreakdown?.components != null) ...[
                const SizedBox(height: 20),
                ..._buildComponentReasonings(),
              ],
              // ── Fallback reasoning label ──
              if ((scoreData?.explanation == null || scoreData!.explanation!.isEmpty) &&
                  (scoreData?.scoringBreakdown?.summary == null ||
                      scoreData!.scoringBreakdown!.summary!.isEmpty)) ...[
                const SizedBox(height: 24),
                const Divider(height: 1, color: AppColors.surface),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SCORING REASONING',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  scoreData?.matchLabel ?? 'AI analysis complete.',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
              // ── Red flags ──
              if (scoreData?.redFlags != null && scoreData!.redFlags!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Divider(height: 1, color: AppColors.surface),
                const SizedBox(height: 20),
                ...scoreData!.redFlags!.map((rf) => WarningCard(rawMessage: rf.message)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _scoreColor(int score) {
    if (score >= 70) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildOverrideBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flash_on, size: 12, color: AppColors.warning),
            const SizedBox(width: 4),
            Text(
              'Override Aktif',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScoreComponents() {
    if (scoreData == null) return [];

    final fields = <_ScoreField>[
      _ScoreField('Skill Match', (s) => s.skillMatchFraction),
      _ScoreField('Experience', (s) => s.experienceFraction),
      _ScoreField('Education', (s) => s.educationFraction),
      _ScoreField('Portfolio', (s) => s.portfolioFraction),
      _ScoreField('Soft Skills', (s) => s.softSkillFraction),
      _ScoreField('Administrative', (s) => s.administrativeFraction),
    ];

    return fields.map((f) {
      final value = f.extractor(scoreData!).clamp(0.0, 1.0);
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildProgressItem(
          f.label,
          value,
          '${(value * 100).round()}%',
        ),
      );
    }).toList();
  }

  Widget _buildProgressItem(String label, double value, String percent) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500)),
            Text(percent, style: AppTextStyles.bodyM.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.surface,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildComponentReasonings() {
    final components = scoreData!.scoringBreakdown!.components!;
    final list = <Widget>[];
    var index = 0;
    components.forEach((key, detail) {
      if (detail.reasoning != null && detail.reasoning!.isNotEmpty) {
        if (index > 0) {
          list.add(const SizedBox(height: 12));
        }
        list.add(_ComponentReasoningTile(
          label: _componentLabel(key),
          rating: detail.rating,
          reasoning: detail.reasoning!,
        ));
        index++;
      }
    });
    return list;
  }

  static String _componentLabel(String key) {
    switch (key) {
      case 'skill_match':
        return 'Skill Match';
      case 'experience':
        return 'Experience';
      case 'education':
        return 'Education';
      case 'portfolio':
        return 'Portfolio';
      case 'soft_skill':
        return 'Soft Skills';
      case 'administrative':
        return 'Administrative';
      default:
        return key;
    }
  }
}

class _ScoreField {
  final String label;
  final double Function(CandidateScore) extractor;
  const _ScoreField(this.label, this.extractor);
}

class _RiskBadge extends StatelessWidget {
  final String riskLevel;
  const _RiskBadge({required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (riskLevel) {
      'low' => (AppColors.success.withValues(alpha: 0.1), AppColors.success, 'Low Risk'),
      'medium' => (AppColors.warning.withValues(alpha: 0.1), AppColors.warning, 'Medium Risk'),
      'high' => (AppColors.error.withValues(alpha: 0.1), AppColors.error, 'High Risk'),
      _ => (AppColors.surface, AppColors.textSecondary, riskLevel),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}


class _ComponentReasoningTile extends StatelessWidget {
  final String label;
  final int rating;
  final String reasoning;
  const _ComponentReasoningTile({
    required this.label,
    required this.rating,
    required this.reasoning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    size: 14,
                    color: i < rating
                        ? AppColors.warning
                        : AppColors.textTertiary,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reasoning,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
