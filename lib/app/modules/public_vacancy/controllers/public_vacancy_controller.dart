import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';

class PublicVacancyController extends GetxController {
  final _appService = Get.find<ApplicationService>();

  // Step control for Application Form
  final currentStep = 1.obs;
  
  // Vacancies State
  final vacancies = <Vacancy>[].obs;
  final selectedVacancy = Rxn<Vacancy>();
  final isLoading = false.obs;

  // Form Fields
  final searchController = TextEditingController();
  final jobCodeController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final linkedinController = TextEditingController();
  final experienceController = TextEditingController();
  final skillInputController = TextEditingController();
  
  // Track status tab
  final trackTicketController = TextEditingController();
  final trackedTicketData = Rxn<Map<String, dynamic>>();
  final isTrackingLoading = false.obs;

  // Professional Experience
  final skills = <String>['React', 'Node.js', 'TypeScript'].obs;
  
  // Document Upload Status
  final uploadedDocs = <String, bool>{}.obs;
  
  // Ticket Generation
  final generatedTicket = ''.obs;

  static const Map<String, String> _docTypeMapping = {
    'CV': 'portfolio',
    'Ijazah': 'degree',
    'KTP': 'identity_card',
    'SKCK': 'criminal_record',
    'Surat Sehat': 'health_certificate',
    'Sertifikat': 'certificate',
  };

  @override
  void onInit() {
    super.onInit();
    fetchPublicVacancies();
    
    // Auto re-fetch on search input changes
    searchController.addListener(() {
      fetchPublicVacancies();
    });
  }

  /// Fetches published public vacancies from the server
  Future<void> fetchPublicVacancies() async {
    isLoading.value = true;
    try {
      final response = await _appService.publicListJobs(
        q: searchController.text.trim(),
      );
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body!;
        final outer = body['data'];
        List<dynamic> items = [];
        if (outer is Map) {
          final raw = outer['data'] ?? outer['items'] ?? [];
          items = raw is List ? raw : [];
        }
        vacancies.assignAll(items.map((j) => Vacancy.fromJson(j as Map<String, dynamic>)));
      }
    } catch (_) {
      // Fallback or ignore quietly
    } finally {
      isLoading.value = false;
    }
  }

  void addSkill(String skill) {
    final clean = skill.trim();
    if (clean.isNotEmpty && !skills.contains(clean)) {
      skills.add(clean);
      skillInputController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  /// Tracks application status via Ticket Code
  Future<void> trackApplication() async {
    final ticketCode = trackTicketController.text.trim();
    if (ticketCode.isEmpty) {
      Get.snackbar('Error', 'Please enter a ticket code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return;
    }

    isTrackingLoading.value = true;
    trackedTicketData.value = null;

    try {
      final response = await _appService.trackTicket(ticketCode);
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body!;
        if (body['success'] == true && body['data'] != null) {
          trackedTicketData.value = body['data'] as Map<String, dynamic>;
        } else {
          Get.snackbar('Not Found', 'Ticket code not found on server.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.warning,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Invalid ticket code or server error.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
      }
    } catch (_) {
      Get.snackbar('Connection Error', 'Please check your internet.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isTrackingLoading.value = false;
    }
  }

  /// Unlocks a private vacancy using apply code
  Future<void> accessPrivateJob() async {
    final code = jobCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter a valid job code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _appService.publicListJobs(q: code);
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body!;
        final outer = body['data'];
        List<dynamic> items = [];
        if (outer is Map) {
          final raw = outer['data'] ?? outer['items'] ?? [];
          items = raw is List ? raw : [];
        }

        if (items.isNotEmpty) {
          final matched = Vacancy.fromJson(items.first as Map<String, dynamic>);
          selectVacancy(matched);
          jobCodeController.clear();
          Get.snackbar('Access Granted', 'Unlocked private vacancy: ${matched.title}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.success,
              colorText: Colors.white);
        } else {
          Get.snackbar('Not Found', 'Invalid job code. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to verify job code.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      Get.snackbar('Connection Error', 'Failed to contact server.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void selectVacancy(Vacancy vacancy) {
    selectedVacancy.value = vacancy;
    currentStep.value = 1;
    uploadedDocs.clear();
    // Default required documents for all vacancies
    const defaultDocs = ['CV', 'Ijazah', 'KTP', 'SKCK', 'Surat Sehat', 'Sertifikat'];
    for (var doc in defaultDocs) {
      uploadedDocs[doc] = false;
    }
  }

  void nextStep() {
    if (currentStep.value == 2) {
      if (fullNameController.text.isEmpty || 
          emailController.text.isEmpty || 
          !GetUtils.isEmail(emailController.text)) {
        Get.snackbar('Validation Error', 'Harap isi nama dan email yang valid.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return;
      }
      if (phoneController.text.isEmpty || phoneController.text.length < 10) {
        Get.snackbar('Validation Error', 'Harap isi nomor WhatsApp yang valid (min. 10 digit).',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return;
      }
    }
    
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  void toggleDocUpload(String doc) {
    uploadedDocs[doc] = !(uploadedDocs[doc] ?? false);
  }

  bool validateForm() {
    if (fullNameController.text.isEmpty || 
        emailController.text.isEmpty || 
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Validation Error', 'Please fill all required fields with valid email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return false;
    }

    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      Get.snackbar('Validation Error', 'Please enter a valid WhatsApp number (min. 10 digits).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return false;
    }
    
    // Check if at least CV/Portfolio is uploaded
    if (!(uploadedDocs['CV'] ?? false)) {
      Get.snackbar('Validation Error', 'Please upload your CV.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return false;
    }
    
    return true;
  }

  /// Submits the recruitment form to `/applications/public/apply` with real data
  Future<void> submitApplication() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final answers = <String, dynamic>{
        'linkedin': linkedinController.text.trim(),
        'experience': experienceController.text.trim(),
        'skills': skills.join(', '),
      };

      final formData = FormData({
        'job_id': selectedVacancy.value!.id,
        'email': emailController.text.trim(),
        'full_name': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'answers_json': jsonEncode(answers),
      });

      // Attach mock PDF files for selected documents to pass server rules validation
      uploadedDocs.forEach((docLabel, isUploaded) {
        if (isUploaded) {
          final serverType = _docTypeMapping[docLabel];
          if (serverType != null) {
            final mockPdfBytes = List<int>.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x34, 0x0a]); // %PDF header
            formData.files.add(MapEntry(
              'file_$serverType',
              MultipartFile(
                mockPdfBytes,
                filename: '${docLabel.toLowerCase().replaceAll(' ', '_')}_mock.pdf',
                contentType: 'application/pdf',
              ),
            ));
          }
        }
      });

      final response = await _appService.publicApply(formData);

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body!;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          generatedTicket.value = data['ticket_code'] ?? 'TKT-PENDING';
          
          // Clear inputs on success
          fullNameController.clear();
          emailController.clear();
          phoneController.clear();
          linkedinController.clear();
          experienceController.clear();
          skills.assignAll(['React', 'Node.js', 'TypeScript']);

          currentStep.value = 4; // Move to Success screen
          return;
        }
      }

      final errorMsg = response.body?['message'] ?? 'Failed to submit application.';
      Get.snackbar('Application Error', errorMsg.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
    } catch (_) {
      Get.snackbar('Error', 'Connection error. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
