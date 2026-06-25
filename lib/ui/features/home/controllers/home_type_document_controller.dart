import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/ui/features/home/repositories_impl/home_type_document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/home/services/home_type_document_service.dart';
import 'package:get/get.dart';

class HomeTypeDocumentController extends GetxController {
  final HomeTypeDocumentService service;

  HomeTypeDocumentController({HomeTypeDocumentService? service}) : service = service ?? HomeTypeDocumentService(repository: HomeTypeDocumentRepositoryImpl());

  final typeData = AsyncValue<List<DocumentSummaryModel>>.init().obs;

  bool get isLoading => typeData.value.state == AsyncValueState.loading;
  List<DocumentSummaryModel> get documents => typeData.value.data ?? [];

  Future<void> fetchTypes() async {
    typeData.value = AsyncValue.loading();

    try {
      final result = await service.fetchTypes();
      typeData.value = AsyncValue.success(result);
    } catch (e) {
      typeData.value = AsyncValue.error(e.toString());
    }
  }

  @override
  void onInit() {
    fetchTypes();
    super.onInit();
  }
}
