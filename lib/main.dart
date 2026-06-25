import 'package:e_doc_redo/services/auth_service.dart';
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/main/main_screen.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  Get.put(AuthService(), permanent: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'E-Doc',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const MainScreen(),
    );
  }
}
