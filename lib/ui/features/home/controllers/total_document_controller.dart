import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/ui/features/home/repositories_impl/total_document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/home/services/total_document_service.dart';
import 'package:get/get.dart';

class TotalDocumentController extends GetxController {
  final TotalDocumentService service;

  TotalDocumentController({TotalDocumentService? service}) : service = service ?? TotalDocumentService(repository: TotalDocumentRepositoryImpl());

  final totalData = AsyncValue<List<DocumentSummaryModel>>.init().obs;

  bool get isLoading => totalData.value.state == AsyncValueState.loading;
  List<DocumentSummaryModel> get data => totalData.value.data ?? [];

  Future<void> fetchTotals() async {
    totalData.value = AsyncValue.loading();

    try {
      final result = await service.fetchTotals();
      totalData.value = AsyncValue.success(result);
    } catch (e) {
      totalData.value = AsyncValue.error(e.toString());
    }
  }

  @override
  void onInit() {
    fetchTotals();
    super.onInit();
  }
}
