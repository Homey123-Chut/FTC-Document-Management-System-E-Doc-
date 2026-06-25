import 'dart:convert';

import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/data/repositories/user/user_repository.dart';
import 'package:file_picker/file_picker.dart';


class ProfileService {
  final UserRepository _repository;

  ProfileService(this._repository);

  Future<UserModel?> getProfileById(String userId) {
    return _repository.getUserById(userId);
  }

  Future<UserModel?> updateProfile(UserModel user) {
    return _repository.updateUser(user);
  }

  Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) {
    return _repository.changePassword(userId, oldPassword, newPassword);
  }

  /// Picks an image file using [FilePicker].
  /// Returns a base64 data URI (e.g. "data:image/jpeg;base64,..."),
  /// or null if the user cancelled. Works cross-platform (web + native).
  Future<String?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return null;

    final mime = _mimeFromExtension(file.extension ?? 'png');
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }

  /// Maps a file extension to its MIME type.
  String _mimeFromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/png';
    }
  }

  /// Uploads a profile image and returns the stored image URI.
  Future<String?> uploadProfileImage(String userId, String imageUri) {
    return _repository.uploadProfileImage(userId, imageUri);
  }
}
