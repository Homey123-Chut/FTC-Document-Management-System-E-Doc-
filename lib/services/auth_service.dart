import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _currentUser = Rx<UserModel?>(null);

  UserModel? get currentUser => _currentUser.value;

  bool get isLoggedIn => _currentUser.value != null;

  /// Staff: មន្រ្តី
  bool get isStaff =>
      _currentUser.value?.role.trim() == 'មន្រ្តី';

  /// Admin: អ្នកគ្រប់គ្រងប្រព័ន្ធ
  bool get isAdmin =>
      _currentUser.value?.role.trim() == 'អ្នកគ្រប់គ្រងប្រព័ន្ធ';

  /// Director: ប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល, ប្រធានការិយាល័យ
  bool get isDirector {
    final role = _currentUser.value?.role.trim() ?? '';
    return role == 'ប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល' ||
        role == 'ប្រធានការិយាល័យ';
  }

  /// Deputy director: អនុប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល, អនុប្រធានការិយាល័យ
  bool get isDeputyDirector {
    final role = _currentUser.value?.role.trim() ?? '';
    return role == 'អនុប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល' ||
        role == 'អនុប្រធានការិយាល័យ';
  }

  void login(UserModel user) {
    _currentUser.value = user;
  }

  void setUser(UserModel? user) {
    _currentUser.value = user;
  }

  void logout() {
    _currentUser.value = null;
  }
}
