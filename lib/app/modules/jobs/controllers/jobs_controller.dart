import 'package:get/get.dart';
import 'package:flutter/foundation.dart';


import 'package:uifrontendmobile/app/services/scoring_service.dart';

class JobsController extends GetxController {
  final _scoringService = Get.find<ScoringService>();
  final currentStep = 1.obs;

  // Step 1: Job Core
  final jobTitle = ''.obs;
  final department = 'Engineering'.obs;
  final employmentType = 'Full-time'.obs;
  final location = 'Remote'.obs;
  final salaryMin = ''.obs;
  final salaryMax = ''.obs;
  final jobDescription = ''.obs;
  final responsibilities = ''.obs;
  final benefits = ''.obs;

  // Step 2: Requirement Builder
  final requiredSkills = <String>['React.js', 'TypeScript'].obs;
  final preferredSkills = <String>['Node.js', 'Docker'].obs;
  final minExperience = '3-5 Years'.obs;
  final educationMin = 'Bachelor\'s'.obs;
  final certifications = <String>[].obs;
  final languages = <String>['English'].obs;
  final workModel = 'Remote'.obs; // shift / WFO / remote

  // Step 3: Applicant Form Setup
  final customFields = [
    {'name': 'Full Name', 'required': true, 'locked': true},
    {'name': 'Email & Phone', 'required': true, 'locked': false},
    {'name': 'Education', 'required': true, 'locked': false},
    {'name': 'Work Experience', 'required': true, 'locked': false},
  ].obs;


  // Step 4: Scoring Weights & Publish Control
  final skillMatchWeight = 30.0.obs;
  final experienceWeight = 25.0.obs;
  final educationWeight = 15.0.obs;
  final portfolioWeight = 15.0.obs;
  final softSkillWeight = 10.0.obs;
  final administrativeWeight = 5.0.obs;

  double get totalWeight => 
      skillMatchWeight.value + 
      experienceWeight.value + 
      educationWeight.value + 
      portfolioWeight.value + 
      softSkillWeight.value + 
      administrativeWeight.value;

  final publishStatus = 'Public (Live)'.obs; // Public/Private
  final isScheduled = false.obs;
  final scheduledDate = ''.obs;
  final generateApplyCode = true.obs;

  void updateWeight(RxDouble weight, double value) {
    weight.value = value;
  }

  void nextStep() async {
    if (currentStep.value == 4) {
      // Direct transition to success for better UX in dev/demo
      currentStep.value = 5;

      // Background process: Perform Publish + Save Weights
      try {
        _scoringService.saveTemplate(
          jobId: "NEW_JOB_ID", 
          skillMatch: skillMatchWeight.value,
          experience: experienceWeight.value,
          education: educationWeight.value,
          portfolio: portfolioWeight.value,
          softSkill: softSkillWeight.value,
          administrative: administrativeWeight.value,
        ).then((response) {
          if (!response.status.isOk) {
            debugPrint("API Background Error: ${response.statusText}");
          }
        });
      } catch (e) {
        debugPrint("Background Exception: $e");
      }
    } else if (currentStep.value < 5) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  // Helper methods
  void addSkill(String skill, bool isRequired) {
    if (skill.isNotEmpty) {
      if (isRequired && !requiredSkills.contains(skill)) {
        requiredSkills.add(skill);
      }
      if (!isRequired && !preferredSkills.contains(skill)) {
        preferredSkills.add(skill);
      }
    }
  }

  void removeSkill(String skill, bool isRequired) {
    if (isRequired) {
      requiredSkills.remove(skill);
    } else {
      preferredSkills.remove(skill);
    }
  }

  void toggleFieldRequired(int index) {
    if (customFields[index]['locked'] == false) {
      bool current = customFields[index]['required'] as bool;
      customFields[index]['required'] = !current;
      customFields.refresh();
    }
  }

  void addCustomField(String name) {
    if (name.isNotEmpty) {
      customFields.add({'name': name, 'required': false, 'locked': false});
    }
  }

  void removeCustomField(int index) {
    if (customFields[index]['locked'] == false) {
      customFields.removeAt(index);
    }
  }
}
