// import 'package:e_doc/ui/features/document/type_documents/ui/views/widgets/general_report_screen.dart';
// import 'package:flutter/material.dart';

// import 'package:e_doc/core/theme/theme.dart';
// import 'package:e_doc/data/repositories/docs/report_repository.dart';
// import 'package:e_doc/models/documents/reports.dart';
// import 'package:e_doc/ui/features/document/type_documents/repositories_impl/report_repositoy_impl.dart';
// import 'package:e_doc/ui/widgets/actions/button.dart';
// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/report_card.dart';
// import 'package:e_doc/ui/features/document/type_documents/ui/widgets/form/create_report.dart';
// import 'package:get/get.dart';

// class ReportSection extends StatefulWidget {
//   const ReportSection({super.key});

//   @override
//   State<ReportSection> createState() => _ReportSectionState();
// }

// class _ReportSectionState extends State<ReportSection> {
//   bool _isExpanded = true;
//   late final ReportRepository _reportRepository;
//   List<ReportModel> _reports = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _reportRepository = ReportRepositoryImpl();
//     _loadReports();
//   }

//   Future<void> _loadReports() async {
//     final reports = await _reportRepository.fetchReports();
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
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.withAlpha(30)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withAlpha(4),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               onTap: () => setState(() => _isExpanded = !_isExpanded),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       'ថតដាក់ឯកសារ',
//                       style: AppTextStyles.headline6,
//                     ),
//                     const Spacer(),
//                     AnimatedRotation(
//                       turns: _isExpanded ? 0.0 : 0.5,
//                       duration: const Duration(milliseconds: 200),
//                       child: const Icon(
//                         Icons.keyboard_arrow_up_rounded,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Divider(height: 1, indent: 16, endIndent: 16),
//             AnimatedCrossFade(
//               firstChild: const SizedBox(width: double.infinity),
//               secondChild: _buildExpandedContent(),
//               crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//               duration: const Duration(milliseconds: 250),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpandedContent() {
//     if (_isLoading) {
//       return const Padding(
//         padding: EdgeInsets.all(8),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final int displayCount = _reports.length > 5 ? 5 : _reports.length;
//     final int gridItemCount =
//         _reports.length > 5 ? displayCount + 1 : displayCount;

//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   'រាយបញ្ជីថតដាក់ឯកសារ',
//                   style: AppTextStyles.subtitle1.copyWith(
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 height: 50,
//                 width: 45,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.withAlpha(40)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.tune_rounded,
//                     size: 18,
//                     color: Colors.grey,
//                   ),
//                   padding: EdgeInsets.zero,
//                 ),
//               ),
//               const SizedBox(width: 8),

//               SizedBox(
//                 width: 200,
//                 child: ButtonWidget(
//                   text: 'បង្កើតសំណុំឯកសារ',
//                   icon: Icons.add,
//                   onPressed: _openCreateReportDialog,
//                 ),
//               ),
//             ],
//           ),
          
  

//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: gridItemCount,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 1.15,
//             ),
//             itemBuilder: (context, index) {
//               if (index < displayCount) {
//                 final report = _reports[index];
//                 return ReportCardWidget(
//                   title: report.title,
//                   totalFiles: report.files,
//                   onTap: () {},
//                 );
//               }

//               return InkWell(
//                 onTap: () => Get.to(() => const GeneralReportScreen()),
//                 borderRadius: BorderRadius.circular(16),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.withAlpha(30)),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF4F7FF),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Icon(
//                           Icons.apps_rounded,
//                           color: Color(0xFF0F4C81),
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'បង្ហាញបន្ថែម',
//                         style: AppTextStyles.body1.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }