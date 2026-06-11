// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/form/create_report.dart';
// import 'package:flutter/material.dart';

// import 'package:e_doc/core/theme/theme.dart';
// import 'package:e_doc/models/documents/reports.dart';
// import 'package:e_doc/ui/features/document/type_documents/services/general_document_service.dart';
// import 'package:e_doc/ui/widgets/actions/button.dart';
// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/report_card.dart';

// class GeneralReportContent extends StatefulWidget {
//   const GeneralReportContent({super.key, GeneralDocumentService? service}) : _service = service ?? const GeneralDocumentService();

//   final GeneralDocumentService _service;

//   @override
//   State<GeneralReportContent> createState() => _GeneralReportContentState();
// }

// class _GeneralReportContentState extends State<GeneralReportContent> {
//   List<ReportModel> _reports = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadReports();
//   }

//   Future<void> _loadReports() async {
//     final reports = await widget._service.fetchReports();
//     if (!mounted) {
//       return;
//     }
//     setState(() {
//       _reports = reports;
//       _isLoading = false;
//     });
//   }

//   void _openCreateReportDialog() {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return CreateReportWidget(
//           onCancel: () => Navigator.of(context).pop(),
//           onCreate: (title) {
//             final newReport = ReportModel(
//               id: DateTime.now().millisecondsSinceEpoch.toString(),
//               title: title,
//               files: 0,
//             );
//             setState(() {
//               _reports = [newReport, ..._reports];
//             });
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center, // Center aligns items horizontally
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'រាយបញ្ជីថតដាក់ឯកសារ',
//                       style: AppTextStyles.subtitle1.copyWith(
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 40, 
//                     width: 40,  
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.withAlpha(40)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.tune_rounded,
//                         size: 20,
//                         color: Colors.grey,
//                       ),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   SizedBox(
//                     width: 200, 
//                     child: ButtonWidget(
//                       text: 'បង្កើតសំណុំឯកសារ',
//                       icon: Icons.add,
//                       onPressed: _openCreateReportDialog,
//                     ),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 16), 
              
//               _buildReportGrid(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildReportGrid() {
//     if (_isLoading) {
//       return const Padding(
//         padding: EdgeInsets.all(32.0),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_reports.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Text('មិនមានថតឯកសារទេ'),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(), // Handled perfectly by parent SingleChildScrollView
//         itemCount: _reports.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1.20, // Increased from 1.15 to shrink heights and maximize safety
//         ),
//         itemBuilder: (context, index) {
//           final report = _reports[index];
//           return ReportCardWidget(
//             title: report.title,
//             totalFiles: report.files,
//             onTap: () {},
//           );
//         },
//       ),
//     );
//   }
// }