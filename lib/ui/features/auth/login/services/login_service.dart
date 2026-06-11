import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/data/repositories/user/user_repository.dart';


class LoginService {
  final UserRepository _repository;

  LoginService(this._repository);

  Future<UserModel?> auth(String email, String password) {
    return _repository.login(email, password);
  }
}
