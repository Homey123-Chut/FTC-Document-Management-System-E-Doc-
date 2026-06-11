
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/controllers/user_controller.dart';
import 'package:e_doc_redo/ui/features/document/type_document_card/views/type_document_screen.dart';
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
    TypeDocumentScreen(),
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
