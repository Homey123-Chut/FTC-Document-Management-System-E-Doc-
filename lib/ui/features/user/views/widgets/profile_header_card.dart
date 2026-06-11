import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String imageUrl;
  final String roleLabel;
  final String userName;
  final String departmentLabel;
  final String departmentName;
  final VoidCallback? onCameraTap;

  const ProfileHeaderCard({
    super.key,
    required this.imageUrl,
    required this.roleLabel,
    required this.userName,
    required this.departmentLabel,
    required this.departmentName,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Interactive Avatar Stack Frame
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0), // Outer ring separation padding
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE5E9F0), // Subtle light grey border frame ring
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFFF1F3F7),
                  backgroundImage: imageUrl.startsWith('http')
                      ? NetworkImage(imageUrl)
                      : AssetImage(imageUrl) as ImageProvider,
                ),
              ),
              // Floating camera badge overlay button
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF2F9), // Light blue-grey background tint
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0, // Clean separation gap from user avatar image
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF1B5ECF), // Royal blue theme color
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),

          // 2. Localized User Profile Context Strings
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                roleLabel,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A92A6), // Soft label grey
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                ' . ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A92A6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1A1A), // Crisp primary midnight black text
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                departmentLabel,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A92A6),
                ),
              ),
              const Text(
                ' . ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A92A6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                departmentName,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF555962), // Dark slate secondary grey text
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}