import 'package:get/get.dart';
import '../../../data/models/vacancy_model.dart';

class JobsListController extends GetxController {
  final jobs = <Vacancy>[].obs;
  final selectedFilter = 'All'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;
    // Mock data fetching
    await Future.delayed(const Duration(seconds: 1));
    
    jobs.assignAll([
      Vacancy(
        id: '1',
        title: 'Senior UI Designer',
        department: 'Design',
        location: 'Remote',
        type: 'Full-time',
        salary: r'$5000 - $8000',
        description: 'We are looking for a Senior UI Designer...',
        requirements: ['Figma', 'Prototyping'],
        docs: ['CV', 'Portfolio'],
        status: 'published',
        applicantCount: 124,
        postedAt: '2 days ago',
      ),
      Vacancy(
        id: '2',
        title: 'Product Manager',
        department: 'Product',
        location: 'Hybrid',
        type: 'Full-time',
        salary: r'$6000 - $9000',
        description: 'Lead our product strategy...',
        requirements: ['Agile', 'Roadmapping'],
        docs: ['CV'],
        status: 'published',
        applicantCount: 45,
        postedAt: '5 days ago',
      ),
      Vacancy(
        id: '3',
        title: 'Backend Engineer',
        department: 'Engineering',
        location: 'Remote',
        type: 'Contract',
        salary: r'$4000 - $7000',
        description: 'Build scalable APIs...',
        requirements: ['Node.js', 'PostgreSQL'],
        docs: ['CV', 'Github'],
        status: 'draft',
        applicantCount: 0,
        postedAt: 'Just now',
      ),
      Vacancy(
        id: '4',
        title: 'Marketing Specialist',
        department: 'Marketing',
        location: 'On-site',
        type: 'Part-time',
        salary: r'$2000 - $3000',
        description: 'Grow our brand presence...',
        requirements: ['SEO', 'Content Strategy'],
        docs: ['CV'],
        status: 'closed',
        applicantCount: 89,
        postedAt: '1 month ago',
      ),
    ]);
    
    isLoading.value = false;
  }

  List<Vacancy> get filteredJobs {
    if (selectedFilter.value == 'All') return jobs;
    return jobs.where((j) => j.status.toLowerCase() == selectedFilter.value.toLowerCase()).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
