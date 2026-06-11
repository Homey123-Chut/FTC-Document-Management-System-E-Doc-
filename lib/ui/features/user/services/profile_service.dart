import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/data/repositories/user/user_repository.dart';


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
}
