import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/document_controller.dart';
import 'package:get/get.dart';

/// Service for creating a new document.
/// Pulls together the correct [DocumentController] by tag and handles the
/// creation call so the [CreateDocumentController] stays lean.
class CreateDocumentService {
  /// Creates [doc] in the matching document-controller bucket.
  /// Returns `true` on success.
  Future<bool> createDocument({
    required DocumentModel doc,
    required String selectedTypeName,
    required String widgetTypeName,
  }) async {
    final selectedTag = 'doc_$selectedTypeName';
    final widgetTag = 'doc_$widgetTypeName';
    final ctrl = Get.isRegistered<DocumentController>(tag: selectedTag)
        ? Get.find<DocumentController>(tag: selectedTag)
        : Get.find<DocumentController>(tag: widgetTag);

    await ctrl.createDocument(doc);
    return true;
  }
}
