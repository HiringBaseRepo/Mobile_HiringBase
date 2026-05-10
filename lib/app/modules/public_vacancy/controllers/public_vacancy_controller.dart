import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';

class PublicVacancyController extends GetxController {
  // Step control for Application Form
  final currentStep = 1.obs;
  
  // Vacancy Data (Mock)
  final vacancies = <Vacancy>[
    const Vacancy(
      id: 'VAC-001',
      title: 'Senior Software Engineer',
      department: 'Engineering',
      location: 'Remote',
      type: 'Full-time',
      salary: r'$5,000 - $8,000',
      description: 'We are looking for a Senior Software Engineer to join our core team...',
      requirements: ['Dart/Flutter', 'GetX', 'Node.js', 'PostgreSQL'],
      docs: ['Ijazah', 'KTP', 'SKCK', 'Surat Sehat', 'Sertifikat'],
    ),
    const Vacancy(
      id: 'VAC-002',
      title: 'Product Designer',
      department: 'Design',
      location: 'Hybrid',
      type: 'Full-time',
      salary: r'$4,000 - $6,500',
      description: 'Join our design team to create beautiful and intuitive user experiences...',
      requirements: ['Figma', 'Prototyping', 'User Research', 'Design Systems'],
      docs: ['Ijazah', 'KTP', 'SKCK', 'Surat Sehat', 'Sertifikat'],
    )
  ].obs;

  final selectedVacancy = Rxn<Vacancy>();

  // Form Fields
  final searchController = TextEditingController();
  final jobCodeController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final linkedinController = TextEditingController();
  final experienceController = TextEditingController();
  final skillInputController = TextEditingController();
  final trackTicketController = TextEditingController();
  
  // Professional Experience
  final skills = <String>['React', 'Node.js', 'TypeScript'].obs;
  
  // Document Upload Status (Mock)
  final uploadedDocs = <String, bool>{}.obs;
  
  // Ticket Generation
  final generatedTicket = ''.obs;

  void addSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills.add(skill);
      skillInputController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void trackApplication() {
    if (trackTicketController.text.isNotEmpty) {
      // Mock tracking logic
      Get.snackbar('Tracking', 'Searching for ticket: ${trackTicketController.text}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void accessPrivateJob() {
    if (jobCodeController.text.isNotEmpty) {
      Get.snackbar('Private Access', 'Searching for job with code: ${jobCodeController.text}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.info,
          colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Please enter a valid job code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
    }
  }

  void selectVacancy(Vacancy vacancy) {
    selectedVacancy.value = vacancy;
    currentStep.value = 1; // Reset to detail view
    uploadedDocs.clear();
    // Initialize required docs from vacancy
    for (var doc in vacancy.docs) {
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
    
    // Check if all docs are uploaded
    final requiredDocs = selectedVacancy.value?.docs ?? [];
    for (var doc in requiredDocs) {
      if (!(uploadedDocs[doc] ?? false)) {
        Get.snackbar('Validation Error', 'Please upload your $doc.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return false;
      }
    }
    
    return true;
  }

  void submitApplication() {
    if (validateForm()) {
      // Logic for duplicate apply validation (Mock)
      /* 
      bool isDuplicate = false; 
      if (isDuplicate) {
        Get.snackbar('Duplicate Application', 'You have already applied for this position with this email.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.warning,
            colorText: Colors.white);
        return;
      }
      */

      // Generate Ticket
      final year = DateTime.now().year;
      final randomId = (10000 + (DateTime.now().millisecondsSinceEpoch % 90000)).toString();
      generatedTicket.value = 'TKT-$year-$randomId';
      
      currentStep.value = 4; // Success step
    }
  }

}
