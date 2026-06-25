import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/ui/features/document/document_type/services/type_document_service.dart';
import 'package:e_doc_redo/ui/features/document/document_type/repositories_impl/type_document_repository_impl.dart';
import 'package:get/get.dart';

class TypeDocumentController extends GetxController {
  final TypeDocumentService service;

  TypeDocumentController({TypeDocumentService? service}) : service = service ?? TypeDocumentService(repository: TypeDocumentRepositoryImpl());

  final documentState = AsyncValue<List<DocumentSummaryModel>>.init().obs;

  bool get isLoading => documentState.value.state == AsyncValueState.loading;
  List<DocumentSummaryModel> get documents => documentState.value.data ?? [];

  Future<void> loadDocuments() async {
    documentState.value = AsyncValue.loading();

    try {
      final items = await service.fetchTypes();
      documentState.value = AsyncValue.success(items);
    } catch (e) {
      documentState.value = AsyncValue.error(e.toString());
    }
  }

  @override
  void onInit() {
    loadDocuments();
    super.onInit();
  }
}
