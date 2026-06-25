import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_total_extension.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/ui/features/home/views/widgets/total_document_card.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_document_type_card.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final List<DocumentSummaryModel> totals;
  final List<DocumentSummaryModel> typeDocuments;
  final void Function(String type) onNavigateToDocuments;

  const HomeContent({
    super.key,
    required this.totals,
    required this.typeDocuments,
    required this.onNavigateToDocuments,
  });

  int _statsColumns(double width) {
    if (width >= 700) return 4;
    if (width >= 500) return 3;
    return 2;
  }

  int _quickActionColumns(double width) {
    if (width >= 700) return 6;
    if (width >= 500) return 5;
    if (width >= 400) return 4;
    return 3;
  }

  double _statsAspectRatio(int columns) {
    switch (columns) {
      case 4:
        return 1.05;
      case 3:
        return 1.1;
      default:
        return 1.2;
    }
  }

  double _quickAspectRatio(int columns) {
    switch (columns) {
      case 6:
        return 0.7;
      case 5:
        return 0.75;
      case 4:
        return 0.8;
      default:
        return 0.85;
    }
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(availableWidth),

              const SizedBox(height: 24),

              Text('សកម្មភាពរហ័ស', style: AppTextStyles.subtitle2),
              const SizedBox(height: 12),
              _buildQuickActions(availableWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(double availableWidth) {
    final columns = _statsColumns(availableWidth);

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: _statsAspectRatio(columns),
      ),
      children: totals.map((item) {
        final statsType = DocumentTotalExtension.fromString(item.type);
        return TotalDocumentCard(
          icon: statsType.icon,
          title: item.title,
          count: item.count,
          backgroundColor: statsType.color,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(double availableWidth) {
    final columns = _quickActionColumns(availableWidth);

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: _quickAspectRatio(columns),
      ),
      children: typeDocuments.map((doc) {
        final docType = DocumentTypeX.fromString(doc.type);
        return EdocDocumentTypeCard(
          icon: docType.icon,
          title: doc.title,
          count: doc.count,
          backgroundColor: docType.color,
          onTap: () => onNavigateToDocuments(doc.type),
        );
      }).toList(),
    );
  }
}
