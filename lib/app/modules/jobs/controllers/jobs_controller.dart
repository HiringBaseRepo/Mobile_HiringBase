import 'package:get/get.dart';

class JobsController extends GetxController {
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


  // Step 4: Publish Control
  final publishStatus = 'Public (Live)'.obs; // Public/Private
  final isScheduled = false.obs;
  final scheduledDate = ''.obs;
  final generateApplyCode = true.obs;

  void nextStep() {
    if (currentStep.value < 5) {
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
      if (isRequired && !requiredSkills.contains(skill))
        requiredSkills.add(skill);
      if (!isRequired && !preferredSkills.contains(skill))
        preferredSkills.add(skill);
    }
  }

  void removeSkill(String skill, bool isRequired) {
    if (isRequired)
      requiredSkills.remove(skill);
    else
      preferredSkills.remove(skill);
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
