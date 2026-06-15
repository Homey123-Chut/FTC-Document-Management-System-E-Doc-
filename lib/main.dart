
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/controllers/user_controller.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/detail_document_screen.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/views/detail_incoming_document_screen.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/view/document_screen.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/view/folder_screen.dart';
import 'package:e_doc_redo/ui/features/home/view/home_screen.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/notification/views/notification_screen.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/user_screen.dart';
import 'package:e_doc_redo/ui/features/welcome/views/welcome_screen.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:e_doc_redo/ui/features/auth/login/services/auth_service.dart';
void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService());
        Get.put(UserController());
        Get.put(ProfileController());
        Get.put(NotificationController());
      }),
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'E-Doc',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      // Register routes so that Get.to() works in Flutter web
      // and browser URL restores don't cause "initial route" errors.
      getPages: [
        GetPage(
          name: '/FoldersScreen',
          page: () {
            final type = Get.arguments as DocumentType? ?? DocumentType.personal;
            return FoldersScreen(type: type);
          },
        ),
        GetPage(
          name: '/DetailDocumentScreen',
          page: () {
            final documentId = Get.arguments?.toString();
            if (documentId == null || documentId.isEmpty) {
              return const MainScreen(); // fallback when arguments are missing (e.g. web refresh)
            }
            Get.delete<DocumentDetailController>();
            final controller = Get.put(DocumentDetailController());
            controller.loadDocument(documentId);
            return const DetailDocumentScreen();
          },
        ),
        GetPage(
          name: '/DetailIncomingDocumentScreen',
          page: () {
            final documentId = Get.arguments?.toString();
            if (documentId == null || documentId.isEmpty) {
              return const MainScreen();
            }
            Get.delete<DocumentDetailController>();
            final controller = Get.put(DocumentDetailController());
            controller.loadDocument(documentId);
            return const DetailIncomingDocumentScreen();
          },
        ),
      ],
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const WelcomeScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    DocumentScreen(),
    NotificationScreen(),
    UserScreen(),
  ];

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: screens[selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          backgroundColor: AppColors.darkBlue,
          elevation: 4,
          onPressed: () {},
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }
}
