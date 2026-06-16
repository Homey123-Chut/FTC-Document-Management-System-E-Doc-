import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:flutter/material.dart';

/// Reusable document card used across all document types.
///
/// - When [status] is `null` (personal, general, incoming):
///   renders a plain card with title, doc number, date, and a menu button.
/// - When [status] is non-null (outgoing):
///   additionally renders a colored status badge next to the title.
class ListCardDocument extends StatelessWidget {
  final String title;
  final String docNumber;
  final String date;
  final String? status; // null → no badge; non-null → show status badge
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onStatusChanged; // fired with new status khmerTitle

  const ListCardDocument({
    super.key,
    required this.title,
    required this.docNumber,
    required this.date,
    this.status,
    this.onMenuPressed,
    this.onStatusChanged,
  });

  /// Builds a single pill-shaped status badge only when [status] is non-null.
  /// Shows icon + text together inside one colored container.
  /// Tapping it triggers [onStatusChanged] so the user can change the status
  /// (e.g. via bottom sheet). Used only on outgoing documents.
  Widget? _buildStatusBadge() {
    if (status == null || status!.isEmpty) return null;

    final currentStatus = DocumentStatusX.fromString(status!);
    final colors = currentStatus.colors;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currentStatus.icon, size: 14, color: colors['icon']),
          const SizedBox(width: 4),
          Text(
            currentStatus.khmerTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors['text'],
            ),
          ),
        ],
      ),
    );

    if (onStatusChanged != null) {
      return InkWell(
        onTap: () => onStatusChanged!(currentStatus.khmerTitle),
        borderRadius: BorderRadius.circular(20),
        child: badge,
      );
    }

    return badge;
  }

  @override
  Widget build(BuildContext context) {
    final statusBadge = _buildStatusBadge();
    final hasStatus = statusBadge != null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFCACDCD)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // Center-align the more_vert icon with the text when no badge;
        // top-align when a badge is present so the icon doesn't shift.
        crossAxisAlignment:
            hasStatus ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title row (with optional status badge) ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'KantumruyPro',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (statusBadge != null) ...[
                      const SizedBox(width: 8),
                      statusBadge,
                    ],
                  ],
                ),
                const SizedBox(height: 12.0),
                // ── Document number + date row ──
                Row(
                  children: [
                    const Icon(Icons.tag,
                        size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      'លេខលិខិត: $docNumber',
                      style: const TextStyle(
                        fontFamily: 'KantumruyPro',
                        fontSize: 14.0,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Only show the more_vert icon when there is NO status badge
          // (personal, general, incoming). Outgoing documents use the
          // status badge itself as the tappable element instead.
          if (!hasStatus) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.more_vert,
                  color: Color(0xFF1E293B), size: 20),
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
