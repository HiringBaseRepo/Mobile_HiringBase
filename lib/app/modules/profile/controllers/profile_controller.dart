import 'package:get/get.dart';

class ProfileController extends GetxController {
  final activities = <Map<String, String>>[
    {
      'title': 'Login Berhasil',
      'subtitle': 'Anda baru saja login ke sistem',
      'time': '10 Menit yang lalu',
      'type': 'login',
    },
    {
      'title': 'Membuat Job Baru',
      'subtitle': 'Senior Flutter Developer - Fulltime',
      'time': '2 Jam yang lalu',
      'type': 'job',
    },
    {
      'title': 'Update Status Kandidat',
      'subtitle': 'Budi Santoso diubah menjadi Interview',
      'time': '5 Jam yang lalu',
      'type': 'candidate',
    },
    {
      'title': 'Mengirim Email Undangan',
      'subtitle': 'Undangan interview untuk 5 kandidat',
      'time': 'Kemarin, 14:20',
      'type': 'email',
    },
    {
      'title': 'Login Berhasil',
      'subtitle': 'Anda baru saja login ke sistem',
      'time': 'Kemarin, 08:00',
      'type': 'login',
    },
    {
      'title': 'Job Draft Disimpan',
      'subtitle': 'Backend Developer - Remote',
      'time': '2 hari yang lalu',
      'type': 'job',
    },
    {
      'title': 'Review CV Selesai',
      'subtitle': '10 CV kandidat telah di-review',
      'time': '3 hari yang lalu',
      'type': 'candidate',
    },
  ].obs;
}

