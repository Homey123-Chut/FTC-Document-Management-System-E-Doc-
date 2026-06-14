import 'package:e_doc_redo/data/models/document/detail_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/document_detail_repository.dart';
import 'package:e_doc_redo/data/repositories/document/send_document_repository.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/repositories_impl/document_detail_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/repositories_impl/send_document_repository_impl.dart';

/// Service for the document detail screen.
/// Aggregates outgoing document, user, and workflow data.
/// Uses [SendDocumentRepository] for outgoing doc lookups so that newly
/// submitted documents (held in the shared static cache) are found.
class DocumentDetailService {
  final SendDocumentRepository sendDocRepo;
  final DocumentDetailRepository detailRepo;

  DocumentDetailService({
    SendDocumentRepository? sendDocRepo,
    DocumentDetailRepository? detailRepo,
  })  : sendDocRepo = sendDocRepo ?? SendDocumentRepositoryImpl(),
        detailRepo = detailRepo ?? DocumentDetailRepositoryImpl();

  /// Builds a [DetailDocumentModel] from multiple data sources.
  Future<DetailDocumentModel> getDocumentDetail(String id) async {
    // Use SendDocumentRepository to find the document (shared static cache)
    final doc = await sendDocRepo.getOutgoingDocumentById(id);
    if (doc == null) {
      throw Exception('Document not found: $id');
    }

    // Fetch creator info from user.json via detailRepo
    final user = await detailRepo.getUserById(doc.createdBy);
    final creatorName = user?.username ?? 'មិនស្គាល់';
    final creatorDepartment = user?.department ?? '';

    // Build attached files list (split by comma if multiple)
    final attachedFiles = doc.attachedFile.isNotEmpty
        ? doc.attachedFile.split(',').map((f) => f.trim()).toList()
        : <String>[];

    return DetailDocumentModel(
      document: doc,
      creatorName: creatorName,
      creatorDepartment: creatorDepartment,
      attachedFiles: attachedFiles,
      approvalSteps: doc.workflowSteps,
      workflowName: doc.workflowTemplateName,
      totalSteps: doc.totalSteps,
    );
  }
}
