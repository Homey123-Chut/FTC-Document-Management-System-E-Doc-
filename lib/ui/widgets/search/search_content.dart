import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/widgets/search/edoc_search.dart';
import 'package:e_doc_redo/ui/widgets/search/search_empty_state.dart';
import 'package:e_doc_redo/ui/widgets/search/search_no_result_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchContent<T> extends StatelessWidget {
  final TextEditingController searchCtrl;
  final RxString searchQuery;
  final RxBool isLoading;
  final RxList<T> searchResults;
  final void Function(String) onSearchChanged;
  final void Function() onClear;
  final Widget Function(T) buildResultItem;
  final String searchHint;
  final String noResultTitle;
  final String noResultSubtitle;

  const SearchContent({
    super.key,
    required this.searchCtrl,
    required this.searchQuery,
    required this.isLoading,
    required this.searchResults,
    required this.onSearchChanged,
    required this.onClear,
    required this.buildResultItem,
    this.searchHint = 'ស្វែងរក',
    this.noResultTitle = 'រកមិនឃើញ',
    this.noResultSubtitle = 'សូមព្យាយាមប្រើពាក្យផ្សេង',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EdocSearch(
          controller: searchCtrl,
          hintText: searchHint,
          autofocus: true,
          onChanged: onSearchChanged,
          onClear: onClear,
        ),

        Expanded(child: Obx(() => _buildBody())),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchQuery.value.isEmpty) {
      return  SearchEmptyState(
        icon: Icons.search,
        title: 'ស្វែងរក',
      );
    }


    if (searchResults.isEmpty) {
      return SearchNoResultState(
        title: noResultTitle,
      );
    }

    final count = searchResults.length;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: count + 1, 
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '$count លទ្ធផល',
              style: AppTextStyles.body3,
            ),
          );
        }
        return buildResultItem(searchResults[index - 1]);
      },
    );
  }
}
