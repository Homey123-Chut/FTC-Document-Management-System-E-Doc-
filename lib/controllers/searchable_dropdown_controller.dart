import 'package:get/get.dart';

/// Reactive controller for [SearchableDropdown].
///
/// Manages the list of items, search filtering, and selected value.
/// The widget itself is pure UI — all state and filter logic lives here.
class SearchableDropdownController<T> extends GetxController {
  /// The complete unfiltered list of items.
  final List<T> allItems;

  /// Function that returns the display label for an item.
  final String Function(T item) itemLabel;

  /// Callback when the user selects an item.
  final void Function(T? value) onChanged;

  SearchableDropdownController({
    required this.allItems,
    required this.itemLabel,
    required this.onChanged,
    T? initialValue,
  }) : _selectedItem = initialValue;

  // ── Reactive state ────────────────────────────────────────────────────

  /// The currently selected item.
  T? _selectedItem;
  T? get selectedItem => _selectedItem;

  /// Items that match the current search text.
  final filteredItems = <T>[].obs;

  /// Current search text entered by the user.
  final searchText = ''.obs;

  /// Whether the dropdown overlay is currently visible.
  final isOpen = false.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _resetFilter();
  }

  // ── Filter logic ──────────────────────────────────────────────────────

  /// Filters [allItems] by [query] (case-insensitive substring match)
  /// and updates [filteredItems].
  void filter(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      _resetFilter();
      return;
    }

    final lower = query.toLowerCase();
    filteredItems.value = allItems
        .where((item) => itemLabel(item).toLowerCase().contains(lower))
        .toList();
  }

  /// Resets the filtered list to show all items.
  void _resetFilter() {
    filteredItems.value = List<T>.from(allItems);
  }

  // ── Selection ─────────────────────────────────────────────────────────

  /// Selects [item], updates state, notifies [onChanged], and closes the
  /// overlay.
  void select(T item) {
    _selectedItem = item;
    searchText.value = itemLabel(item);
    onChanged(item);
    close();
  }

  /// Returns the display label for the currently selected item, or the
  /// "select…" hint when nothing is selected.
  String get displayText {
    if (_selectedItem != null) return itemLabel(_selectedItem as T);
    if (searchText.value.isNotEmpty) return searchText.value;
    return '';
  }

  // ── Overlay control ───────────────────────────────────────────────────

  /// Opens the dropdown overlay and resets the filter.
  void open() {
    isOpen.value = true;
    searchText.value = '';
    _resetFilter();
  }

  /// Closes the dropdown overlay.
  void close() {
    isOpen.value = false;
  }

  /// Toggles the overlay open/closed.
  void toggle() {
    if (isOpen.value) {
      close();
    } else {
      open();
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────

  /// Clears the selection and search text.
  void clear() {
    _selectedItem = null;
    searchText.value = '';
    _resetFilter();
    onChanged(null);
  }
}
