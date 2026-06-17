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
  Future<Response> saveTemplate({
    required String jobId,
    required double skillMatch,
    required double experience,
    required double education,
    required double portfolio,
    required double softSkill,
    required double administrative,
  }) {
    return post('/scoring/templates', {
      'job_id': jobId,
      'skill_match_weight': skillMatch,
      'experience_weight': experience,
      'education_weight': education,
      'portfolio_weight': portfolio,
      'soft_skill_weight': softSkill,
      'administrative_weight': administrative,
    });
  }

  /// Update existing scoring template
  Future<Response> updateTemplate(String templateId, Map<String, dynamic> weights) => 
      patch('/scoring/templates/$templateId', weights);
}
