// import 'package:e_doc/ui/features/document/type_documents/ui/views/report_section.dart';
// import 'package:flutter/material.dart';

// import 'package:e_doc/core/theme/theme.dart';
// import 'package:e_doc/models/documents/document.dart';
// import 'package:e_doc/ui/features/document/type_documents/services/general_document_service.dart';
// import 'package:e_doc/ui/widgets/actions/button.dart';
// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/list_document_card.dart';
// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/form/create_document.dart';

// class GeneralDocumentContent extends StatefulWidget {
//   const GeneralDocumentContent({super.key, GeneralDocumentService? service}) : _service = service ?? const GeneralDocumentService();

//   final GeneralDocumentService _service;

//   @override
//   State<GeneralDocumentContent> createState() => _GeneralDocumentContentState();
// }

// class _GeneralDocumentContentState extends State<GeneralDocumentContent> {
//   List<DocumentModel> _documents = [];
//   bool _isLoading = true;
//   String _selectedFileName = 'ជ្រើសរើសឯកសារភ្ជាប់';

//   @override
//   void initState() {
//     super.initState();
//     _loadDocuments();
//   }

//   Future<void> _loadDocuments() async {
//     try {
//       final documents = await widget._service.fetchDocuments();
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         _documents = documents;
//       });
//     } catch (_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         _documents = [];
//       });
//     } finally {
//       if (!mounted) {
        
//       }
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _openCreateDocumentDialog() {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return CreateDocumentWidget(
//               selectedFileName: _selectedFileName,
//               onUploadTap: () {
//                 setDialogState(() {
//                   _selectedFileName = 'selected_file.pdf';
//                 });
//               },
//               onCancel: () => Navigator.of(context).pop(),
//               onSubmit: (
//                   {required String title,
//                   required String code,
//                   required String documentNumber,
//                   required String subject,
//                   required String program,
//                   required String reference}) {
//                 final newDocument = DocumentModel(
//                   id: DateTime.now().millisecondsSinceEpoch,
//                   titleKhmer: title,
//                   titleLatin: code,
//                   documentNumber: documentNumber,
//                   date: DateTime.now().toIso8601String().split('T').first,
//                   status: 'ថ្មី',
//                   subject: subject,
//                   program: program,
//                   documentHistory: reference,
//                   attachedFile: _selectedFileName,
//                 );
//                 setState(() {
//                   _documents = [newDocument, ..._documents];
//                 });
//                 Navigator.of(context).pop();
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const ReportSection(),
//           const SizedBox(height: 2),
//           _buildDocumentHeader(),
//           const SizedBox(height: 12),
//           _buildDocumentList(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           Text(
//             'ឯកសារទូទៅ',
//             style: AppTextStyles.subtitle1.copyWith(
//               color: Colors.grey[800],
//               fontWeight: FontWeight.w700,
//             ) 
//           ),
//           const Spacer(),
//           Container(
//             height: 44,
//             width: 44,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.withAlpha(40)),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.tune_rounded, size: 20, color: Colors.grey),
//             ),
//           ),
//           const SizedBox(width: 10),
//           ButtonWidget(
//             text: 'បង្កើតឯកសារ',
//             height: 44,
//             icon: Icons.add,
//             onPressed: _openCreateDocumentDialog,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentList() {
//     if (_isLoading) {
//       return const Padding(
//         padding: EdgeInsets.all(28.0),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_documents.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Text('មិនមានឯកសារទេ'),
//       );
//     }

//     return Column(
//       children: [
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: _documents.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 4),
//           itemBuilder: (context, index) {
//             final document = _documents[index];
//             final String title = document.titleKhmer.isNotEmpty
//                 ? document.titleKhmer
//                 : document.titleLatin;

//             return ListDocumentCardWidget(
//               title: title,
//               documentNumber: document.documentNumber,
//               date: document.date,
//               onTap: () {},
//               onMenuPressed: () {},
//             );
//           },
//         ),
//         const SizedBox(height: 6),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {},
//             child: const Text('មើលបន្ថែម >'),
//           ),
//         ),
//       ],
//     );
//   }
// }