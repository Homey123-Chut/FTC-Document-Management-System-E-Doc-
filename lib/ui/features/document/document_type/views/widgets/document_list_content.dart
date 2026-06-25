import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/folder_section.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/document_controller.dart';
import 'list_card_document.dart';

class DocumentListContent extends StatelessWidget {
  final DocumentType type;
  final FolderController folderController;

  const DocumentListContent({
    super.key,
    required this.type,
    required this.folderController,
  });

  DocumentController get _ctrl =>
      Get.find<DocumentController>(tag: 'doc_${type.name}');

  bool get _isIncoming => type == DocumentType.incoming;
  bool get _isOutgoing => type == DocumentType.outgoing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FolderSection(controller: folderController),
          const SizedBox(height: 12),

          // ── Section header ──────────────────────────────────────────

          Obx(() {
            final inSelection = _ctrl.isSelectionMode.value;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    inSelection
                        ? 'បានជ្រើស ${_ctrl.selectedDocuments.length}'
                        : type.khmerTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (inSelection) ...[
                  TextButton(
                    onPressed: _ctrl.clearSelection,
                    child: const Text(
                      'លុបការជ្រើស',
                      style: TextStyle(color: Color(0xFFDC2626)),
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isIncoming
                        ? () {
                            if (_ctrl.isSelectionMode.value) {
                              _ctrl.clearSelection();
                            } else {
                              _ctrl.isSelectionMode.value = true;
                            }
                          }
                        : () {},
                    icon: Icon(
                      _isIncoming && _ctrl.isSelectionMode.value
                          ? Icons.close
                          : Icons.tune,
                      color: _isIncoming && _ctrl.isSelectionMode.value
                          ? const Color(0xFFDC2626)
                          : Colors.grey,
                    ),
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: _isIncoming && _ctrl.isSelectionMode.value
                            ? const Color(0xFFDC2626)
                            : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ButtonWidget(
                      text: _isOutgoing ? 'បញ្ជូនឯកសារ' : 'បង្កើតឯកសារថ្មី',
                      icon: _isOutgoing ? Icons.send : Icons.add,
                      height: 42,
                      backgroundColor: AppColors.darkBlue,
                      onPressed: _isOutgoing
                          ? _ctrl.openSendDialog
                          : _ctrl.openCreateDialog,
                    ),
                  ),
                ],
              ],
            );
          }),
          const SizedBox(height: 2),

          // ── Selection bar ──────────────────────────────────────────

          Obx(() {
            if (_ctrl.isSelectionMode.value && _ctrl.hasSelection) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ButtonWidget(
                  text: 'បញ្ជូនឯកសារ (${_ctrl.selectedDocuments.length})',
                  icon: Icons.send,
                  width: double.infinity,
                  height: 48,
                  backgroundColor: AppColors.darkBlue,
                  isLoading: _ctrl.isSending.value,
                  onPressed: _ctrl.isSending.value
                      ? null
                      : () => _ctrl.sendSelectedDocuments(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // ── Document list ──────────────────────────────────────────

          Obx(() {
            final allDocs = _ctrl.documents;

            if (allDocs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('មិនទាន់មានឯកសារ', style: AppTextStyles.body2),
                ),
              );
            }

            final displayed = _ctrl.showAllDocuments.value
                ? allDocs
                : allDocs.take(5).toList();

            final isInSelection = _ctrl.isSelectionMode.value;

            return Column(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayed.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final doc = displayed[i];
                    final selected = _ctrl.isSelected(doc);

                    final card = ListCardDocument(
                      title: doc.titleKhmer,
                      docNumber: doc.documentNumber,
                      date: doc.date,
                      status: _isOutgoing || _isIncoming
                          ? doc.status
                          : null,
                      onMenuPressed:
                          (_isOutgoing || _isIncoming) ? null : () {},
                      showCheckbox: isInSelection && _isIncoming,
                      isSelected: selected,
                      onToggleSelection:
                          isInSelection && _isIncoming
                              ? () => _ctrl.toggleSelection(doc)
                              : null,
                      sender: doc.sender,
                      statusLevel: doc.priority,
                    );

                    if (isInSelection && _isIncoming) {
                      return GestureDetector(
                        onTap: () => _ctrl.toggleSelection(doc),
                        child: card,
                      );
                    }

                    if (_isOutgoing) {
                      return GestureDetector(
                        onTap: () =>
                            _ctrl.navigateToOutgoingDetail(doc),
                        child: card,
                      );
                    }
                    if (_isIncoming) {
                      return GestureDetector(
                        onTap: () => _ctrl.navigateToReview(doc),
                        onLongPress: () =>
                            _ctrl.toggleSelection(doc),
                        child: card,
                      );
                    }
                    return card;
                  },
                ),

                // ── Show-more / show-less toggle ──
                if (allDocs.length > 5 && !isInSelection)
                  InkWell(
                    onTap: _ctrl.showAllDocuments.toggle,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _ctrl.showAllDocuments.value
                                ? 'បង្ហាញតិច'
                                : 'បង្ហាញបន្ថែម',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _ctrl.showAllDocuments.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF0284C7),
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          }),

          // ── Recently created section (incoming only) ───────────────

          if (_isIncoming)
            Obx(() {
              final recent = _ctrl.recentDocuments;

              if (recent.isEmpty) return const SizedBox.shrink();

              final isInSelection = _ctrl.isSelectionMode.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'ឯកសារបានបង្កើតថ្មីៗ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recent.length,
                    separatorBuilder: (_, i) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final doc = recent[i];
                      final selected = _ctrl.isSelected(doc);

                      final card = ListCardDocument(
                        title: doc.titleKhmer,
                        docNumber: doc.documentNumber,
                        date: doc.date.isNotEmpty
                            ? doc.date
                            : (doc.createdDate ?? ''),
                        status: doc.status,
                        showCheckbox: isInSelection,
                        isSelected: selected,
                        onToggleSelection: isInSelection
                            ? () => _ctrl.toggleSelection(doc)
                            : null,
                        sender: doc.sender,
                        statusLevel: doc.priority,
                      );

                      if (isInSelection) {
                        return GestureDetector(
                          onTap: () => _ctrl.toggleSelection(doc),
                          child: card,
                        );
                      }

                      return GestureDetector(
                        onTap: () => _ctrl.navigateToReview(doc),
                        onLongPress: () =>
                            _ctrl.toggleSelection(doc),
                        child: card,
                      );
                    },
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
