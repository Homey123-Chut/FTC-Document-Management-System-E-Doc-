import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemLabel;
  final void Function(T? value) onChanged;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.selectedItem,
  });

  void _openBottomSheet(BuildContext context) {
    final searchController = TextEditingController();
    final RxList<T> filteredItems = items.obs;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              "Select $label",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// SEARCH FIELD
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filteredItems.value = items
                    .where((e) => itemLabel(e)
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              },
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return ListTile(
                      title: Text(itemLabel(item)),
                      onTap: () {
                        onChanged(item);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem != null
                  ? itemLabel(selectedItem as T)
                  : "Select $label",
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}