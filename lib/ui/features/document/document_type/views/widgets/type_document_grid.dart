import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_document_type_card.dart';
import 'package:flutter/material.dart';

/// A grid that displays document type cards.
/// Each card shows the icon, title, document count, and navigates
/// to the corresponding document list screen on tap.
class TypeDocumentGrid extends StatelessWidget {
  final List<DocumentSummaryModel> typeDocuments;

  const TypeDocumentGrid({
    super.key,
    required this.typeDocuments,
  });

  @override
  Widget build(BuildContext context) {
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
        final docType = DocumentTypeX.fromString(doc.type);
        return EdocDocumentTypeCard(
          icon: docType.icon,
          title: doc.title,
          count: doc.count,
          backgroundColor: docType.color,
          onTap: () => docType.navigate(),
        );
      }).toList(),
    );
  }
}
