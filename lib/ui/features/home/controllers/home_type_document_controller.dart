import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/ui/features/home/repository_impl/home_type_document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/home/services/home_type_document_service.dart';
import 'package:get/get.dart';

class HomeTypeDocumentController extends GetxController {
  final TypeDocumentService service;

  HomeTypeDocumentController({TypeDocumentService? service})
      : service = service ?? TypeDocumentService(repository: MockTypeDocumentRepository());

  final typeData = AsyncValue<List<TypeDocumentModel>>.init().obs;

  bool get isLoading => typeData.value.state == AsyncValueState.loading;
  List<TypeDocumentModel> get documents => typeData.value.data ?? [];

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
