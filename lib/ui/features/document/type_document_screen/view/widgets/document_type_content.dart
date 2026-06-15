import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/send_document_dialog.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/controllers/document_controller.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/view/widgets/form/document_create_form.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'folder_section.dart';
import 'list_card_document.dart';

/// Displays the folder section and document list for a specific [DocumentType].
/// Reads document data directly from [DocumentController] via Get.find()
/// inside Obx wrappers for instant reactive updates after create/delete.
class DocumentTypeContent extends StatefulWidget {
  final DocumentType type;

  const DocumentTypeContent({
    super.key,
    required this.type,
  });

  @override
  State<DocumentTypeContent> createState() => _DocumentTypeContentState();
}

class _DocumentTypeContentState extends State<DocumentTypeContent> {
  bool _showAllDocuments = false;

  /// Resolves the tagged DocumentController for this screen's type.
  DocumentController get _docCtrl =>
      Get.find<DocumentController>(tag: 'doc_${widget.type.name}');

  void _openCreateDocumentDialog() {
    Get.dialog(
      DocumentCreateForm(type: widget.type),
      barrierDismissible: false,
    );
  }

  void _openSendDocumentDialog() {
    Get.dialog(
      const SendDocumentDialog(),
      barrierDismissible: false,
    );
  }

  /// Shows a bottom sheet to pick a new status for the given outgoing document.
  void _showStatusPicker(DocumentModel doc) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ជ្រើសរើសស្ថានភាព',
                style: TextStyle(
                  fontFamily: 'KantumruyPro',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Divider(),
              ...DocumentStatus.values.map((s) {
                final c = s.colors;
                final selected = doc.status == s.khmerTitle;
                return ListTile(
                  leading: Icon(s.icon, size: 22, color: c['icon']),
                  title: Text(
                    s.khmerTitle,
                    style: TextStyle(
                      fontFamily: 'KantumruyPro',
                      fontWeight: FontWeight.w500,
                      color: c['text'],
                    ),
                  ),
                  selected: selected,
                  selectedTileColor:
                      (c['bg'] as Color).withValues(alpha: 0.3),
                  trailing:
                      selected
                          ? Icon(Icons.check, size: 18, color: c['icon'])
                          : null,
                  onTap: () {
                    _docCtrl.updateDocumentStatus(doc.id, s.khmerTitle);
                    Get.back();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── FOLDER SECTION (reads from FolderController via Obx) ──
          FolderSection(type: widget.type),
          const SizedBox(height: 12),

          // ── DOCUMENT SECTION HEADER ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  widget.type.khmerTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune, color: Colors.grey),
                style: IconButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                fit: FlexFit.loose,
                child: ButtonWidget(
                  text: widget.type == DocumentType.outgoing
                      ? 'បញ្ជូនឯកសារ'
                      : 'បង្កើតឯកសារថ្មី',
                  icon: widget.type == DocumentType.outgoing
                      ? Icons.send
                      : Icons.add,
                  height: 42,
                  backgroundColor: AppColors.darkBlue,
                  onPressed: widget.type == DocumentType.outgoing
                      ? _openSendDocumentDialog
                      : _openCreateDocumentDialog,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // ── DOCUMENT LIST (reactive via Obx) ──
          Obx(() {
            final allDocs = _docCtrl.documents;

            if (allDocs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'មិនទាន់មានឯកសារ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              );
            }

            final displayed =
                _showAllDocuments ? allDocs : allDocs.take(5).toList();

            return Column(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 20), // Adds padding inside the list
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayed.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = displayed[index];
                    final isOutgoing =
                        widget.type == DocumentType.outgoing;
                    final isIncoming =
                        widget.type == DocumentType.incoming;

                    final card = ListCardDocument(
                      title: doc.titleKhmer,
                      docNumber: doc.documentNumber,
                      date: doc.date,
                      // Outgoing & incoming documents get a status badge
                      status: (isOutgoing || isIncoming) ? doc.status : null,
                      // Outgoing: tap badge → open status picker bottom sheet
                      onStatusChanged: (isOutgoing || isIncoming)
                          ? (_) => _showStatusPicker(doc)
                          : null,
                      // Other types: show the more_vert menu icon
                      onMenuPressed:
                          (isOutgoing || isIncoming) ? null : () {},
                    );

                    // Outgoing cards → outgoing detail
                    // Incoming cards → incoming detail (with approve/reject)
                    if (isOutgoing) {
                      return GestureDetector(
                        onTap: () => Get.toNamed('/DetailDocumentScreen',
                            arguments: doc.id.toString()),
                        child: card,
                      );
                    }
                    if (isIncoming) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(
                            '/DetailIncomingDocumentScreen',
                            arguments: doc.id.toString()),
                        child: card,
                      );
                    }
                    return card;
                  },
                ),
                // ── BOTTOM "SHOW MORE" BUTTON ──
                if (allDocs.length > 5)
                  InkWell(
                    onTap: () => setState(
                        () => _showAllDocuments = !_showAllDocuments),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _showAllDocuments
                                ? 'បង្ហាញតិច'
                                : 'បង្ហាញបន្ថែម',
                            style: const TextStyle(
                              fontFamily: 'KantumruyPro',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _showAllDocuments
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF0284C7),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
