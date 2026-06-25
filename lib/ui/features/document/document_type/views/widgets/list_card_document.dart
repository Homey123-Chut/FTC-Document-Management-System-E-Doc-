import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/core/utils/get_status_color.dart';
import 'package:flutter/material.dart';

class ListCardDocument extends StatelessWidget {
  final String title;
  final String docNumber;
  final String date;
  final String? status;
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onStatusChanged;

  final bool showCheckbox;
  final bool isSelected;
  final VoidCallback? onToggleSelection;

  final String? sender;
  final String? statusLevel;

  const ListCardDocument({
    super.key,
    required this.title,
    required this.docNumber,
    required this.date,
    this.status,
    this.onMenuPressed,
    this.onStatusChanged,
    this.showCheckbox = false,
    this.isSelected = false,
    this.onToggleSelection,
    this.sender,
    this.statusLevel,
  });

  // ── Status badge (reusable across card variants) ──────────────────

  Widget? _buildStatusBadge() {
    if (status == null || status!.isEmpty) return null;

    final docStatus = DocumentStatusX.fromString(status!);
    final colors = docStatus.colors;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(docStatus.icon, size: 14, color: colors['icon']),
          const SizedBox(width: 4),
          Text(
            docStatus.khmerTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors['text'],
            ),
          ),
        ],
      ),
    );

    if (onStatusChanged != null) {
      return InkWell(
        onTap: () => onStatusChanged!(docStatus.khmerTitle),
        borderRadius: BorderRadius.circular(20),
        child: badge,
      );
    }

    return badge;
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final statusBadge = _buildStatusBadge();
    final hasStatus = statusBadge != null;
    final hasSender = sender != null && sender!.isNotEmpty;
    final hasstatusLevel = statusLevel != null && statusLevel!.isNotEmpty;
    final showSenderRow = hasSender || hasstatusLevel;
    final showMenu = !hasStatus && !showCheckbox;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCACDCD),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            hasStatus ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // ── Selection checkbox ──
          if (showCheckbox)
            GestureDetector(
              onTap: onToggleSelection,
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.blue : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.blue : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: AppColors.white)
                    : null,
              ),
            ),

          // ── Card content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title + status badge ──
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: AppTextStyles.body6),
                    ),
                    if (hasStatus) ...[
                      const SizedBox(width: 8),
                      statusBadge,
                    ],
                  ],
                ),
                const SizedBox(height: 12.0),

                // ── Document number + date ──
                Row(
                  children: [
                    const Icon(Icons.tag, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'លេខលិខិត: $docNumber',
                        style: AppTextStyles.body3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        date,
                        style: AppTextStyles.body3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // ── Sender + statusLevel (optional) ──
                if (showSenderRow) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (hasSender) ...[
                        const Icon(Icons.person_outline,
                            size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            sender!,
                            style: AppTextStyles.body3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (hasstatusLevel) ...[
                        if (hasSender) const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: statusLevel!.statusLevelColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLevel!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: statusLevel!.statusLevelColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Menu button (hidden when status badge or checkbox shown) ──
          if (showMenu) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.more_vert,
                  color: Color(0xFF1E293B), size: 22),
              onPressed: onMenuPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

}
