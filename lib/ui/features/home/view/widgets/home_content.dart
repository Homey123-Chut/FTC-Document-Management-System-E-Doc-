import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/total_document.dart';
import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/ui/features/home/view/widgets/total_document_card.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_document_type_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/login/services/auth_service.dart';

class HomeContent extends StatelessWidget {
  final List<TotalDocumentModel> totals;
  final List<TypeDocumentModel> typeDocuments;
  final void Function(String type) onNavigateToDocuments;

  const HomeContent({
    super.key,
    required this.totals,
    required this.typeDocuments,
    required this.onNavigateToDocuments,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),

          const SizedBox(height: 24),

          Text('សកម្មភាពរហ័ស', style: AppTextStyles.subtitle3),
          const SizedBox(height: 12),
          _buildQuickActions(),

          Obx(() {
            if (!authService.isAdmin) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  text: 'បង្កើតលំហូរឯកសារ',
                  onPressed: () => onNavigateToDocuments('workflow'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final colorMap = <String, Color>{
      'all': AppColors.darkBlue,
      'pending': AppColors.yellow,
      'approved': AppColors.green,
      'rejected': AppColors.red,
    };
    final iconMap = <String, IconData>{
      'all': Icons.description,
      'pending': Icons.hourglass_empty,
      'approved': Icons.check_circle_outline,
      'rejected': Icons.cancel_outlined,
    };

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: totals.map((item) {
        return TotalDocumentCard(
          icon: iconMap[item.type] ?? Icons.description,
          title: item.title,
          count: item.totalDocs,
          backgroundColor: colorMap[item.type] ?? AppColors.darkBlue,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    final colorMap = <String, Color>{
      'personal': AppColors.lightBlue,
      'general': AppColors.blue,
      'incoming': AppColors.green,
      'outgoing': AppColors.darkBlue,
      'workflow': AppColors.yellow,
      'department': AppColors.red,
    };

    final iconMap = <String, IconData>{
      'personal': Icons.person_outline,
      'general': Icons.description_outlined,
      'incoming': Icons.move_to_inbox_outlined,
      'outgoing': Icons.send_outlined,
      'workflow': Icons.account_tree_outlined,
      'department': Icons.business_outlined,
    };

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      children: typeDocuments.map((doc) {
        return EdocDocumentTypeCard(
          icon: iconMap[doc.type] ?? Icons.folder_outlined,
          title: doc.title,
          count: doc.totalDocs,
          backgroundColor: colorMap[doc.type] ?? AppColors.blue,
          onTap: () => onNavigateToDocuments(doc.type),
        );
      }).toList(),
    );
  }
}
