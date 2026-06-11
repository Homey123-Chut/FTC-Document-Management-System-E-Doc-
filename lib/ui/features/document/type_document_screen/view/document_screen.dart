// import 'package:e_doc/ui/features/document/type_documents/ui/views/type_document_content.dart';
// import 'package:flutter/material.dart';

// import 'package:e_doc/ui/widgets/displays/top_nav_bar.dart';

// class GeneralDocumentScreen extends StatelessWidget {
// 	const GeneralDocumentScreen({super.key});

// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			backgroundColor: const Color(0xFFFAFAFA),
// 			body: Column(
// 				children: [
// 					TopNavBarWidget(
// 						title: 'ឯកសារទូទៅ',
// 						onSearchTap: () {},
// 					),
// 					Expanded(
// 						child: Padding(
// 							padding: const EdgeInsets.only(top: 4.0),
// 							child: GeneralDocumentContent(),
// 						),
// 					),
// 				],
// 			),
// 		);
// 	}
// }

import 'package:flutter/material.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Document'), centerTitle: true),
      body: const Center(
        child: Text(
          'Document Screen',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}