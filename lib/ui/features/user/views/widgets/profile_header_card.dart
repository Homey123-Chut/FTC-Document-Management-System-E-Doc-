import 'dart:convert';

import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String imageUrl;
  final String roleLabel;
  final String userName;
  final String entityLabel;
  final String entityName;
  final VoidCallback? onCameraTap;

  const ProfileHeaderCard({
    super.key,
    required this.imageUrl,
    required this.roleLabel,
    required this.userName,
    required this.entityLabel,
    required this.entityName,
    this.onCameraTap,
  });

  ImageProvider? _buildImageProvider() {
    if (imageUrl.isEmpty) return null;

    if (imageUrl.startsWith('data:image/')) {
      final commaIndex = imageUrl.indexOf(',');
      if (commaIndex != -1) {
        final base64 = imageUrl.substring(commaIndex + 1);
        return MemoryImage(base64Decode(base64));
      }
      return null;
    }

    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }

    return AssetImage(imageUrl) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE5E9F0),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFFF1F3F7),
                  backgroundImage: _buildImageProvider(),
                  child: imageUrl.isEmpty
                      ? const Icon(
                                Icons.person, 
                                size: 48,
                                color: AppColors.darkGray,
                              )
                      : null,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF2F9), 
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2.0, 
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.lightBlue, 
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                roleLabel,
                style: AppTextStyles.subtitle5,
              ),
              Text(
                ' . ',
                style: AppTextStyles.caption1,
              ),
              Text(
                userName,
                style: AppTextStyles.subtitle2.copyWith(
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
                entityLabel,
                style: AppTextStyles.subtitle5,
              ),
              Text(
                ' . ',
                style: AppTextStyles.subtitle5,
              ),
              Text(
                entityName,
                style: AppTextStyles.subtitle2.copyWith(
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}