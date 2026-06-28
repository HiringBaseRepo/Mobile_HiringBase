import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/public_vacancy_controller.dart';

class TrackStatusView extends GetView<PublicVacancyController> {
  const TrackStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () {
            Get.offAllNamed(Routes.SELECTION);
          },
        ),
        title: Text("Lacak Lamaran", style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchCard(),
                const SizedBox(height: 32),
                Obx(() {
                  if (controller.isTrackingLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final data = controller.trackedTicketData.value;
                  if (data == null) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      _buildStatusTimeline(data),
                      const SizedBox(height: 32),
                      _buildAIPulseCard(data),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        children: [
          Icon(Icons.track_changes_outlined, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            "Tidak Ada Lamaran Terpilih",
            style: AppTextStyles.subHeader1,
          ),
          const SizedBox(height: 8),
          Text(
            "Masukkan kode tiket di atas untuk melacak perkembangan rekrutmen Anda secara real-time.",
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Periksa Status Anda", style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            "Masukkan ID tiket unik Anda untuk melihat pembaruan terbaru lamaran Anda.",
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surface),
            ),
            child: TextField(
              controller: controller.trackTicketController,
              style: AppTextStyles.bodyM.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: "TKT-2026-XXXXX",
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  onPressed: controller.trackApplication,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(Map<String, dynamic> data) {
    final status = (data['application_status'] as String? ?? 'applied').toLowerCase();
    final statusLabel = data['application_status_label'] as String? ?? 'Applied';
    final jobTitle = data['job_title'] as String? ?? 'Lowongan';
    final applicantName = data['applicant_name'] as String? ?? 'Pelamar';
    final createdAt = data['created_at'] as String? ?? '';

    String localizedStatusLabel = statusLabel;
    switch (status) {
      case 'applied':
        localizedStatusLabel = 'Baru Terdaftar';
        break;
      case 'doc_check':
        localizedStatusLabel = 'Verifikasi Dokumen';
        break;
      case 'doc_failed':
        localizedStatusLabel = 'Verifikasi Gagal';
        break;
      case 'ai_processing':
        localizedStatusLabel = 'Proses AI';
        break;
      case 'ai_passed':
        localizedStatusLabel = 'Lolos AI';
        break;
      case 'under_review':
        localizedStatusLabel = 'Sedang Ditinjau';
        break;
      case 'interview':
        localizedStatusLabel = 'Wawancara';
        break;
      case 'offered':
        localizedStatusLabel = 'Ditawarkan';
        break;
      case 'hired':
        localizedStatusLabel = 'Diterima';
        break;
      case 'rejected':
        localizedStatusLabel = 'Ditolak';
        break;
      case 'knockout':
        localizedStatusLabel = 'Gugur';
        break;
    }

    // Parse date safely
    String dateStr = 'Baru saja';
    if (createdAt.isNotEmpty) {
      try {
        final dt = DateTime.parse(createdAt);
        const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
        dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {}
    }

    // Determine completion states
    final step1Complete = true;
    final step2Complete = status != 'applied';
    final step2Active = status == 'screening';

    final step3Complete = status == 'interview' || status == 'accepted' || status == 'rejected';
    final step3Active = status == 'interview';

    final step4Complete = status == 'accepted' || status == 'rejected';
    final step4Active = status == 'accepted' || status == 'rejected';

    Color statusColor;
    if (status == 'accepted') {
      statusColor = AppColors.success;
    } else if (status == 'rejected') {
      statusColor = AppColors.error;
    } else {
      statusColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surface, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobTitle, style: AppTextStyles.h3.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(applicantName, style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  localizedStatusLabel.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTimelineItem(
            "Lamaran Diterima",
            "Dikirim pada $dateStr",
            isCompleted: step1Complete,
            isLast: false,
          ),
          _buildTimelineItem(
            "Analisis AI HiringBase",
            step2Complete 
              ? "Analisis skrining AI selesai."
              : (step2Active ? "Analisis skrining awal sedang berlangsung..." : "Mengantre untuk skrining AI."),
            isCompleted: step2Complete,
            isActive: step2Active,
            isLast: false,
          ),
          _buildTimelineItem(
            "Wawancara Kerja",
            step3Complete 
              ? "Wawancara dengan Manajer HRD selesai."
              : (step3Active ? "Wawancara telah dijadwalkan! Perekrut akan segera menghubungi Anda." : "Menunggu tinjauan seleksi."),
            isCompleted: step3Complete,
            isActive: step3Active,
            isLast: false,
          ),
          _buildTimelineItem(
            "Keputusan Akhir",
            status == 'accepted' 
              ? "Selamat! Anda telah diterima untuk posisi ini."
              : (status == 'rejected' ? "Lamaran ditutup. Terima kasih atas partisipasi Anda." : "Menunggu keputusan akhir rekrutmen."),
            isCompleted: step4Complete,
            isActive: step4Active,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, {bool isCompleted = false, bool isActive = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.success : (isActive ? AppColors.primary : AppColors.surface),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary.withValues(alpha: 0.2) : AppColors.transparent,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: AppColors.white, size: 14)
                    : (isActive ? Container(margin: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle)) : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.success : AppColors.surface,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted || isActive ? AppColors.textPrimary : AppColors.textTertiary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIPulseCard(Map<String, dynamic> data) {
    final status = (data['application_status'] as String? ?? 'applied').toLowerCase();
    
    String message = "Profil Anda sedang mengantre untuk diproses. Semoga beruntung!";
    if (status == 'screening') {
      message = "AI HiringBase sedang menilai CV dan kesesuaian keahlian Anda.";
    } else if (status == 'interview') {
      message = "Selamat! Profil Anda memenuhi syarat untuk tahap wawancara selanjutnya.";
    } else if (status == 'accepted') {
      message = "Anda telah berhasil dicocokkan! HRD akan menghubungi Anda dengan surat penawaran kerja.";
    } else if (status == 'rejected') {
      message = "Kami menghargai minat Anda. Kami akan menyimpan CV Anda untuk posisi yang cocok di masa mendatang.";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wawasan HiringBase",
                  style: AppTextStyles.bodyM.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
