import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:e_doc_redo/ui/features/document/services/document_detail_service.dart';
import 'package:get/get.dart';

/// Controller for the document detail screen.
/// Loads the [DetailDocumentModel] by document ID.
class DocumentDetailController extends GetxController {
  final DocumentDetailService service;

  DocumentDetailController({DocumentDetailService? service})
      : service = service ?? DocumentDetailService();

  final detail = Rxn<DetailDocumentModel>();
  final isLoading = true.obs;
  final error = ''.obs;

  /// Loads document detail by its [id].
  Future<void> loadDocument(String id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await service.getDocumentDetail(id);
      detail.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
