import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';

class ScoringService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      if (!request.headers.containsKey('Content-Type')) {
        request.headers['Content-Type'] = 'application/json';
      }
      return request;
    });
    super.onInit();
  }

  /// Get scoring template for a specific job
  Future<Response> getTemplate(String jobId) => 
      get('/scoring/templates/$jobId');

  /// Create new scoring template for a job
  /// Backend expects all params as query parameters (not body), weights as int.
  Future<Response> saveTemplate({
    required String jobId,
    required double skillMatch,
    required double experience,
    required double education,
    required double portfolio,
    required double softSkill,
    required double administrative,
  }) {
    return post('/scoring/templates', {}, query: {
      'job_id': (int.tryParse(jobId) ?? 0).toString(),
      'skill_match_weight': skillMatch.round().toString(),
      'experience_weight': experience.round().toString(),
      'education_weight': education.round().toString(),
      'portfolio_weight': portfolio.round().toString(),
      'soft_skill_weight': softSkill.round().toString(),
      'administrative_weight': administrative.round().toString(),
    });
  }

  /// Update existing scoring template
  Future<Response> updateTemplate(String templateId, Map<String, dynamic> weights) => 
      patch('/scoring/templates/$templateId', weights);

  /// Apply manual score override for an application (replacement mode)
  Future<Response> manualOverride({
    required int applicationId,
    required double skillMatchScore,
    required double experienceScore,
    required double educationScore,
    required double portfolioScore,
    required double softSkillScore,
    required double administrativeScore,
    required String reason,
  }) {
    final queryParams = {
      'skill_match_score': skillMatchScore.toString(),
      'experience_score': experienceScore.toString(),
      'education_score': educationScore.toString(),
      'portfolio_score': portfolioScore.toString(),
      'soft_skill_score': softSkillScore.toString(),
      'administrative_score': administrativeScore.toString(),
      'reason': reason,
    };
    return post('/manual-override/$applicationId', {}, query: queryParams);
  }
}
