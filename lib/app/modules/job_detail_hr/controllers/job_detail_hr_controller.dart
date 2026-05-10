import 'package:get/get.dart';
import '../../../data/models/vacancy_model.dart';

class JobDetailHrController extends GetxController {
  final job = Rxn<Vacancy>();
  final applicantCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Vacancy) {
      job.value = Get.arguments as Vacancy;
    }
    // Mock loading details
    fetchJobDetails();
  }

  Future<void> fetchJobDetails() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    // In reality, fetch updated job info and detailed stats
    applicantCount.value = job.value?.applicantCount ?? 0;
    isLoading.value = false;
  }
}
