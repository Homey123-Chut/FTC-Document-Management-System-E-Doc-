import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:e_doc_redo/data/repositories/document/document_detail_repository.dart';
import 'package:e_doc_redo/data/repositories/document/send_document_repository.dart';
import 'package:e_doc_redo/ui/features/document/repository_impl/document_detail_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/repository_impl/send_document_repository_impl.dart';

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
    final docId = int.tryParse(id) ?? 0;
    final doc = await sendDocRepo.getOutgoingDocumentById(docId);
    if (doc == null) {
      throw Exception('Document not found: $id');
    }

    // Fetch creator info from user.json via detailRepo
    final user = await detailRepo.getUserById(doc.createdBy);
    final creatorName = user?.username ?? 'មិនស្គាល់';
    final creatorDepartment = user?.department ?? '';
    final creatorProfileImg = user?.profileImg ?? '';
    final creatorRole = user?.role ?? '';

    // Determine receiver from first approval step (if any)
    String receiverName = '';
    String receiverDepartment = '';
    String receiverRole = '';
    if (doc.workflowSteps.isNotEmpty) {
      final firstStep = doc.workflowSteps.first;
      receiverName = firstStep.level;
      receiverDepartment = firstStep.flowLevel;
      receiverRole = '';
    }

    // Fetch workflow description
    String workflowDescription = '';
    try {
      final workflows = await detailRepo.getWorkflows();
      for (final wf in workflows) {
        if (wf.id == doc.workflowTemplateId) {
          workflowDescription = wf.description;
          break;
        }
      }
    } catch (_) {}

    // Build attached files list (split by comma if multiple)
    final attachedFiles = doc.attachedFile.isNotEmpty
        ? doc.attachedFile.split(',').map((f) => f.trim()).toList()
        : <String>[];

    return DetailDocumentModel(
      document: doc,
      creatorName: creatorName,
      creatorDepartment: creatorDepartment,
      creatorProfileImg: creatorProfileImg,
      creatorRole: creatorRole,
      attachedFiles: attachedFiles,
      approvalSteps: doc.workflowSteps,
      workflowName: doc.workflowTemplateName,
      totalSteps: doc.totalSteps,
      workflowDescription: workflowDescription,
      receiverName: receiverName.isNotEmpty ? receiverName : (doc.workflowSteps.isNotEmpty ? doc.workflowSteps.first.level : ''),
      receiverDepartment: receiverDepartment.isNotEmpty ? receiverDepartment : (doc.workflowSteps.isNotEmpty ? doc.workflowSteps.first.flowLevel : ''),
      receiverRole: receiverRole,
    );
  }
}
