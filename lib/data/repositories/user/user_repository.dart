import 'package:e_doc_redo/data/models/user/user.dart';

abstract class UserRepository {
  Future<UserModel?> login(String email, String password);

  Future<UserModel?> getUserById(String id);

  Future<UserModel?> updateUser(UserModel user);

  Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
}