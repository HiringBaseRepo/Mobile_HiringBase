import 'dart:convert';
import 'dart:io' as io;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  final educationController = TextEditingController();
  final skillInputController = TextEditingController();
  
  // Track status tab
  final trackTicketController = TextEditingController();
  final trackedTicketData = Rxn<Map<String, dynamic>>();
  final isTrackingLoading = false.obs;

  // Professional Experience
  final skills = <String>['React', 'Node.js', 'TypeScript'].obs;
  
  // Document Upload Status
  final uploadedDocs = <String, bool>{}.obs;
  final selectedFiles = <String, PlatformFile?>{}.obs;
  
  // Ticket Generation
  final generatedTicket = ''.obs;

  // Dynamic Form Fields
  final customFormFields = <Map<String, dynamic>>[].obs;
  final customControllers = <String, TextEditingController>{}.obs;
  final requiredDocLabels = <String>[].obs;

  bool _isDocumentField(String key, String label) {
    final k = key.toLowerCase();
    final l = label.toLowerCase();
    return k.contains('ijazah') || k.contains('ktp') || k.contains('skck') || 
           k.contains('sehat') || k.contains('sertifikat') || k.contains('cv') || 
           k.contains('portfolio') || k.contains('file') || k.contains('document') || 
           k.contains('dokumen') || k.contains('berkas') || k.contains('vaksin') || 
           k.contains('foto') || k.contains('card');
  }

  String _getServerDocType(String label) {
    final l = label.toLowerCase();
    if (l.contains('cv') || l.contains('portfolio') || l.contains('portofolio')) {
      return 'portfolio';
    }
    if (l.contains('ijazah') || l.contains('degree')) {
      return 'degree';
    }
    if (l.contains('ktp') || l.contains('card') || l.contains('identitas')) {
      return 'identity_card';
    }
    if (l.contains('skck') || l.contains('criminal')) {
      return 'criminal_record';
    }
    if (l.contains('sehat') || l.contains('health')) {
      return 'health_certificate';
    }
    if (l.contains('sertifikat') || l.contains('certificate') || l.contains('vaksin')) {
      return 'certificate';
    }
    return 'portfolio'; // Default fallback
  }

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
      print("Track Ticket Status Code: ${response.statusCode}");
      print("Track Ticket Body: ${response.body}");
      print("Track Ticket Status Text: ${response.statusText}");
      
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
        Get.snackbar('Error', 'Invalid ticket code or server error. Status: ${response.statusCode}, Msg: ${response.statusText}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
      }
    } catch (e) {
      print("Track Ticket Exception: $e");
      Get.snackbar('Connection Error', 'Please check your internet. Exception: $e',
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

  void selectVacancy(Vacancy vacancy) async {
    selectedVacancy.value = vacancy;
    currentStep.value = 1;
    uploadedDocs.clear();
    selectedFiles.clear();
    customFormFields.clear();
    requiredDocLabels.clear();
    
    // Dispose old custom controllers
    customControllers.forEach((_, c) => c.dispose());
    customControllers.clear();

    final docList = <String>[];

    // Fetch details to get form_fields
    try {
      final response = await _appService.publicJobDetail(int.parse(vacancy.id));
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body!;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          final updated = Vacancy.fromJson(data);
          selectedVacancy.value = updated;
          final fields = data['form_fields'] as List? ?? [];
          
          final standardKeys = {
            'full_name', 'email', 'email_address', 'phone', 
            'phone_number', 'whatsapp', 'education', 
            'work_experience', 'experience', 'linkedin', 'skills'
          };
          
          for (var f in fields) {
            if (f is Map<String, dynamic>) {
              final label = f['label']?.toString() ?? '';
              final key = f['field_key']?.toString();
              
              if (key != null) {
                final isDoc = _isDocumentField(key, label);
                if (isDoc) {
                  if (!docList.contains(label)) {
                    docList.add(label);
                  }
                  if (f['is_required'] == true) {
                    requiredDocLabels.add(label);
                  }
                } else {
                  customFormFields.add(f);
                  if (!standardKeys.contains(key.toLowerCase())) {
                    customControllers[key] = TextEditingController();
                  }
                }
              }
            }
          }
        }
      }
    } catch (_) {
      // Ignore
    }

    // Initialize uploaded docs
    for (var doc in docList) {
      uploadedDocs[doc] = false;
      selectedFiles[doc] = null;
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

  Future<void> pickDocument(String docLabel) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // 5MB limit
        const maxSizeBytes = 5 * 1024 * 1024;
        if (file.size > maxSizeBytes) {
          Get.snackbar(
            'File Terlalu Besar',
            'Ukuran file ${file.name} melebihi batas 5MB.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          return;
        }

        selectedFiles[docLabel] = file;
        uploadedDocs[docLabel] = true;
      }
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        'Gagal memilih file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  void removeDocument(String docLabel) {
    selectedFiles[docLabel] = null;
    uploadedDocs[docLabel] = false;
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

    // Validate custom required fields
    for (var field in customFormFields) {
      final key = field['field_key']?.toString();
      final isRequired = field['is_required'] as bool? ?? false;
      final label = field['label']?.toString() ?? 'Field';
      
      if (isRequired) {
        if (key == 'linkedin' && linkedinController.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Field \'$label\' wajib diisi.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error,
              colorText: Colors.white);
          return false;
        } else if ((key == 'experience' || key == 'work_experience') && experienceController.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Field \'$label\' wajib diisi.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error,
              colorText: Colors.white);
          return false;
        } else if (key == 'education' && educationController.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Field \'$label\' wajib diisi.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error,
              colorText: Colors.white);
          return false;
        } else if (key != null && customControllers.containsKey(key)) {
          final controller = customControllers[key]!;
          if (controller.text.trim().isEmpty) {
            Get.snackbar('Validation Error', 'Field \'$label\' wajib diisi.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.error,
                colorText: Colors.white);
            return false;
          }
        }
      }
    }

    // Validate required documents
    for (var docLabel in requiredDocLabels) {
      if (uploadedDocs[docLabel] != true || selectedFiles[docLabel] == null) {
        Get.snackbar('Validation Error', 'Dokumen \'$docLabel\' wajib diunggah.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return false;
      }
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
        'education': educationController.text.trim(),
        'skills': skills.join(', '),
      };

      // Add other custom fields dynamically
      customControllers.forEach((key, controller) {
        answers[key] = controller.text.trim();
      });

      final formData = FormData({
        'job_id': selectedVacancy.value!.id,
        'email': emailController.text.trim(),
        'full_name': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'answers_json': jsonEncode(answers),
      });

      // Helper function to map mime type / extension
      String getContentTypeForFile(String filename) {
        final ext = filename.split('.').last.toLowerCase();
        switch (ext) {
          case 'pdf':
            return 'application/pdf';
          case 'jpg':
          case 'jpeg':
            return 'image/jpeg';
          case 'png':
            return 'image/png';
          default:
            return 'application/octet-stream';
        }
      }

      // Attach actual picked files to formData
      selectedFiles.forEach((docLabel, file) {
        if (file != null) {
          final serverType = _getServerDocType(docLabel);
          if (file.bytes != null) {
            formData.files.add(MapEntry(
              'file_$serverType',
              MultipartFile(
                file.bytes!,
                filename: file.name,
                contentType: getContentTypeForFile(file.name),
              ),
            ));
          } else if (file.path != null) {
            formData.files.add(MapEntry(
              'file_$serverType',
              MultipartFile(
                io.File(file.path!),
                filename: file.name,
                contentType: getContentTypeForFile(file.name),
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
          educationController.clear();
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

  @override
  void onClose() {
    customControllers.forEach((_, c) => c.dispose());
    super.onClose();
  }
}
