import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/home/screens/home_screen.dart';
import 'package:e_doc_redo/ui/features/document/views/document_screen.dart';
import 'package:e_doc_redo/ui/features/notification/screens/notification_screen.dart';
import 'package:e_doc_redo/ui/features/user/screens/user_screen.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

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
