import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _currentUser = Rx<UserModel?>(null);

  UserModel? get currentUser => _currentUser.value;
  bool get isAdmin => _currentUser.value?.role == 'admin';
  bool get isLoggedIn => _currentUser.value != null;

  void setUser(UserModel? user) {
    _currentUser.value = user;
  }

  void logout() {
    _currentUser.value = null;
  }
}
