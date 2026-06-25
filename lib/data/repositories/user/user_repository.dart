import 'package:e_doc_redo/data/models/user/user.dart';

abstract class UserRepository {
  Future<UserModel?> login(String email, String password);

  Future<UserModel?> getUserById(String id);

  Future<List<UserModel>> fetchAllUsers();

  Future<UserModel?> updateUser(UserModel user);

  Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );

  /// Uploads a profile image for the given user.
  /// [filePath] is the absolute path to the image file on the device.
  /// Returns the new profile image path/URL on success, or null on failure.
  Future<String?> uploadProfileImage(String userId, String filePath);
}