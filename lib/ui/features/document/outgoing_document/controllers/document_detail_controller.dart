import 'dart:async';
import 'package:e_doc_redo/services/download_service.dart';
import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/services/document_detail_service.dart';
import 'package:get/get.dart';

/// Controller for the document detail screen.
/// Loads the [DetailDocumentModel] by document ID and manages per-file
/// download state so the UI widgets remain stateless and reusable.
class DocumentDetailController extends GetxController {
  final DocumentDetailService service;

  DocumentDetailController({DocumentDetailService? service})
      : service = service ?? DocumentDetailService();

  // ── Document state ──────────────────────────────────────────────────────

  final detail = Rxn<DetailDocumentModel>();
  final isLoading = true.obs;
  final error = ''.obs;

  // ── Download state ──────────────────────────────────────────────────────

  /// Tracks successfully downloaded files: fileName → localPath.
  final downloadedFiles = <String, String>{}.obs;

  /// Per-file download status.
  final downloadStatuses = <String, DownloadStatus>{}.obs;

  /// Per-file download progress (0.0 – 1.0).
  final downloadProgress = <String, double>{}.obs;

  final DownloadService _downloadService = DownloadService();
  StreamSubscription<DownloadProgress>? _downloadSubscription;

  // ── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _listenToDownloadStream();
  }

  @override
  void onClose() {
    _downloadSubscription?.cancel();
    _downloadService.dispose();
    super.onClose();
  }

  // ── Document loading ────────────────────────────────────────────────────

  /// Loads document detail by its [id].
  Future<void> loadDocument(String id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await service.getDocumentDetail(id);
      detail.value = result;
      // Restore any previously downloaded files from the model
      downloadedFiles.assignAll(result.downloadedFiles);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Download orchestration ──────────────────────────────────────────────

  /// Starts downloading [fileName]. Progress is pushed into [downloadProgress]
  /// and [downloadStatuses] so widgets can react.
  Future<void> downloadFile(String fileName) async {
    final currentStatus = downloadStatuses[fileName];
    if (currentStatus == DownloadStatus.downloading ||
        currentStatus == DownloadStatus.completed) {
      return;
    }

    downloadStatuses[fileName] = DownloadStatus.downloading;
    downloadProgress[fileName] = 0.0;

    await _downloadService.downloadFile(fileName);
  }

  /// Returns true if [fileName] has been downloaded.
  bool isFileDownloaded(String fileName) =>
      downloadedFiles.containsKey(fileName);

  /// Registers a file as downloaded and updates the detail model.
  void _addDownloadedFile(String fileName, String localPath) {
    downloadedFiles[fileName] = localPath;
    final current = detail.value;
    if (current != null) {
      final updated = Map<String, String>.from(current.downloadedFiles);
      updated[fileName] = localPath;
      detail.value = DetailDocumentModel(
        document: current.document,
        creatorName: current.creatorName,
        creatorDepartment: current.creatorDepartment,
        creatorProfileImg: current.creatorProfileImg,
        creatorRole: current.creatorRole,
        attachedFiles: current.attachedFiles,
        approvalSteps: current.approvalSteps,
        workflowName: current.workflowName,
        totalSteps: current.totalSteps,
        workflowDescription: current.workflowDescription,
        receiverName: current.receiverName,
        receiverDepartment: current.receiverDepartment,
        receiverRole: current.receiverRole,
        downloadedFiles: updated,
      );
    }
  }

  // ── Internal stream wiring ──────────────────────────────────────────────

  void _listenToDownloadStream() {
    _downloadSubscription = _downloadService.progressStream.listen((p) {
      downloadStatuses[p.fileName] = p.status;
      downloadProgress[p.fileName] = p.progress;

      if (p.status == DownloadStatus.completed) {
        _addDownloadedFile(p.fileName, p.localPath ?? '');
      }
    });
  }
}
