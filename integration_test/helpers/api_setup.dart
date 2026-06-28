import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/app/services/app_service.dart';

import 'test_config.dart';

class ApiSetupResult {
  final String applyCode;
  final int jobId;
  final int applicationId;
  final String ticketCode;

  ApiSetupResult({
    required this.applyCode,
    required this.jobId,
    required this.applicationId,
    required this.ticketCode,
  });
}

class ApiSetup {
  static const _baseUrl = 'http://localhost:8000/api/v1';
  static String? _token;
  static final GetConnect _http = GetConnect(timeout: const Duration(seconds: 30));

  static Future<ApiSetupResult> runSetup() async {
    final log = <String>[];

    // 1. Login
    final loginResp = await _http.post('$_baseUrl/auth/login', {
      'email': TestConfig.hrEmail,
      'password': TestConfig.hrPassword,
    });
    if (loginResp.statusCode != 200 || loginResp.body == null) {
      debugPrint('API SETUP: login status=${loginResp.statusCode} body=${loginResp.body}');
      throw Exception('Login failed');
    }
    final data = loginResp.body['data'] as Map<String, dynamic>?;
    _token = data?['access_token'] as String?;
    if (_token == null) {
      debugPrint('API SETUP: login body = ${loginResp.body}');
      throw Exception('No access_token');
    }
    Get.find<AppService>().accessToken.value = _token!;
    Get.find<AppService>().currentRole.value = 'hr';

    _http.httpClient.addRequestModifier<dynamic>((req) {
      req.headers['Authorization'] = 'Bearer $_token';
      return req;
    });
    log.add('login ok');

    // 2. Create job step 1
    final s1 = await _http.post('$_baseUrl/jobs/create-step1', {
      'title': TestConfig.jobTitle,
      'description': TestConfig.jobDescription,
      'employment_type': 'full_time',
    });
    final jobId = (s1.body['data']?['job_id'] as num?)?.toInt();
    if (jobId == null) throw Exception('step1 failed: ${s1.body}');
    log.add('job=$jobId');

    // Step 2: requirements
    await _http.post('$_baseUrl/jobs/$jobId/step2-requirements', {
      'requirements': TestConfig.jobSkills.map((s) => {
        'category': 'skill',
        'name': s,
        'value': s,
        'is_required': true,
        'priority': 1,
      }).toList(),
    });
    log.add('reqs ok');

    // Step 3: form fields
    await _http.post('$_baseUrl/jobs/$jobId/step3-form', {
      'fields': [
        {'field_key': 'education_level', 'field_type': 'text', 'label': 'Education Level', 'is_required': true},
        {'field_key': 'experience_years', 'field_type': 'text', 'label': 'Experience Years', 'is_required': true},
        {'field_key': 'experience_summary', 'field_type': 'textarea', 'label': 'Experience Summary', 'is_required': false},
        {'field_key': 'skills', 'field_type': 'text', 'label': 'Skills', 'is_required': false},
        {'field_key': 'github_url', 'field_type': 'url', 'label': 'GitHub URL', 'is_required': false},
        {'field_key': 'portfolio_url', 'field_type': 'url', 'label': 'Live Project URL', 'is_required': false},
      ],
    });
    log.add('form ok');

    // Step 4: publish
    final pub = await _http.post('$_baseUrl/jobs/$jobId/step4-publish', {'mode': 'public'});
    final applyCode = pub.body['data']?['apply_code'] as String? ?? '';
    log.add('apply_code=$applyCode');

    // 3. Apply (multipart)
    final answers = {
      'education_level': 'S1 Computer Science',
      'experience_years': '3',
      'experience_summary': 'Full-stack developer with 3 years experience',
      'skills': 'Flutter, Python, FastAPI, PostgreSQL',
    };
    final formData = FormData({
      'job_id': jobId.toString(),
      'email': TestConfig.applicantEmail,
      'full_name': TestConfig.applicantName,
      'phone': TestConfig.applicantPhone,
      'answers_json': answers.keys.map((k) => '$k: ${answers[k]}').join('\n'),
    });

    final docMap = {
      'file_degree': 'ijazah.pdf',
      'file_identity_card': 'ktp.pdf',
      'file_criminal_record': 'skck.pdf',
      'file_health_certificate': 'surat_sehat.pdf',
      'file_certificate': 'sertifikat.pdf',
    };
    for (final entry in docMap.entries) {
      final file = File('${TestConfig.testDocDir}/${entry.value}');
      if (await file.exists()) {
        formData.files.add(MapEntry(
          entry.key,
          MultipartFile(await file.readAsBytes(), filename: entry.value),
        ));
      }
    }

    final applyResp = await _http.post('$_baseUrl/applications/public/apply', formData);
    if (applyResp.statusCode != 200 || applyResp.body == null) {
      throw Exception('Apply failed: ${applyResp.body}');
    }
    final applicationId = (applyResp.body['data']?['application_id'] as num?)?.toInt();
    final ticketCode = applyResp.body['data']?['ticket_code'] as String? ?? '';
    if (applicationId == null) throw Exception('No application_id');
    log.add('applied=$applicationId ticket=$ticketCode');

    // 4. Screening
    await _http.post('$_baseUrl/screening/applications/$applicationId/run', null);
    log.add('screening triggered');

    // 5. Poll for score
    int score = 0;
    for (int i = 0; i < 15; i++) {
      await Future.delayed(const Duration(seconds: 5));
      final d = await _http.get('$_baseUrl/applications/$applicationId');
      if (d.statusCode == 200 && d.body != null) {
        score = (d.body['data']?['score'] as num?)?.toInt() ?? 0;
        if (score > 0) break;
      }
      log.add('poll$i: score=$score');
    }

    debugPrint('API SETUP: ${log.join(' | ')} | final_score=$score');

    return ApiSetupResult(
      applyCode: applyCode,
      jobId: jobId,
      applicationId: applicationId,
      ticketCode: ticketCode,
    );
  }
}
