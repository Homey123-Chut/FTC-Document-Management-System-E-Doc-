import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Button with Icon',
                icon: Icons.arrow_forward,
                width: 20,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              ButtonWidget(
                text: 'Smart Fallback (Grey Text)',
                backgroundColor: AppColors.lightBlue,
                icon: Icons.info_outline,
                width: 20,
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}