import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/controllers/searchable_dropdown_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A searchable dropdown that matches the visual style of [DropdownField]
/// but adds type-to-filter behaviour.
///
/// When the user taps the field all options appear.  Typing filters the
/// list instantly.  Selecting an item displays it in the field and closes
/// the dropdown.
///
/// All filter/selection logic lives in [SearchableDropdownController];
/// this widget is pure UI — it only displays data and receives interaction.
class SearchableDropdown<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemLabel;
  final void Function(T? value) onChanged;
  final TextStyle? labelStyle;
  final TextStyle? selectedTextStyle;
  final String? hintText;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.selectedItem,
    this.labelStyle,
    this.selectedTextStyle,
    this.hintText,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late final SearchableDropdownController<T> _controller;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = SearchableDropdownController<T>(
      allItems: widget.items,
      itemLabel: widget.itemLabel,
      onChanged: (value) {
        widget.onChanged(value);
        // After selection, show selected label in the field.
        if (value != null) {
          _textController.text = widget.itemLabel(value);
        }
      },
      initialValue: widget.selectedItem,
    );

    // Init text field with the current selection (if any)
    if (widget.selectedItem != null) {
      _textController.text = widget.itemLabel(widget.selectedItem as T);
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _onFieldTap();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFieldTap() {
    if (!_controller.isOpen.value) {
      _controller.open();
      // Clear text so user can type a new search
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label (matches DropdownField styling) ───────────────────────
        Text(
          widget.label,
          style: widget.labelStyle ?? AppTextStyles.caption1,
        ),
        const SizedBox(height: 8),

        // ── Field + dropdown overlay ────────────────────────────────────
        CompositedTransformTarget(
          link: _layerLink,
          child: Obx(() {
            final isOpen = _controller.isOpen.value;

            return Column(
              children: [
                // ── Text field (styled like DropdownField) ──────────────
                TextFormField(
                  focusNode: _focusNode,
                  controller: _textController,
                  onChanged: (value) => _controller.filter(value),
                  onTap: _onFieldTap,
                  style: widget.selectedTextStyle ?? AppTextStyles.subtitle4,
                  decoration: InputDecoration(
                    hintText: widget.hintText ??
                        (_controller.selectedItem == null
                            ? 'ជ្រើសរើស ${widget.label}'
                            : null),
                    hintStyle: AppTextStyles.body2,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => _controller.toggle(),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.darkBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // ── Dropdown overlay ────────────────────────────────────
                if (isOpen)
                  CompositedTransformFollower(
                    link: _layerLink,
                    offset: const Offset(0, 52),
                    showWhenUnlinked: false,
                    child: _DropdownOverlay<T>(
                      controller: _controller,
                      onItemSelected: (item) {
                        _controller.select(item);
                        _focusNode.unfocus();
                      },
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// ─── Dropdown overlay ──────────────────────────────────────────────────────

/// The floating dropdown list that appears below the search field.
/// Renders filtered items inside a styled container matching the project
/// design system.
class _DropdownOverlay<T> extends StatelessWidget {
  final SearchableDropdownController<T> controller;
  final void Function(T item) onItemSelected;

  const _DropdownOverlay({
    required this.controller,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 240,
          maxWidth: MediaQuery.of(context).size.width - 32,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        child: Obx(() {
          final items = controller.filteredItems;

          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'រកមិនឃើញ',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final label = controller.itemLabel(item);

              return InkWell(
                onTap: () => onItemSelected(item),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    label,
                    style: AppTextStyles.label1,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
