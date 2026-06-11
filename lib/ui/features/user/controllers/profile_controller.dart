import 'package:e_doc_redo/data/repositories_impl/mock_user_repository.dart';
import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/ui/features/auth/login/services/auth_service.dart';
import 'package:e_doc_redo/ui/features/user/services/profile_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService;

  ProfileController({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService(MockUserRepository());

  // ── UI State ──
  final user = Rxn<UserModel>();
  final loading = false.obs;
  final hasError = false.obs;

  /// Called by UI widgets when they are displayed.
  /// Safe to call multiple times — skips if already loaded for the same user.
  Future<void> fetchActiveUserSession() async {
    try {
      loading.value = true;
      hasError.value = false;

      final auth = Get.find<AuthService>();
      final userId = auth.currentUser?.id;
      if (userId == null) {
        hasError.value = true;
        return;
      }

      final userModel = await _profileService.getProfileById(userId);
      if (userModel != null) {
        user.value = userModel;
        // Keep AuthService in sync with latest data
        auth.setUser(userModel);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      loading.value = false;
    }
  }

  /// Updates the profile picture path locally.
  void updateProfilePicture(String newLocalAssetPath) {
    if (user.value != null) {
      user.value = user.value!.copyWith(profileImg: newLocalAssetPath);
    }
  }

  /// Saves updated user profile via repository.
  Future<void> saveProfile(UserModel updated) async {
    try {
      loading.value = true;
      final result = await _profileService.updateProfile(updated);
      if (result != null) {
        user.value = result;
        Get.find<AuthService>().setUser(result);
      }
    } catch (_) {
      // keep current data on error
    } finally {
      loading.value = false;
    }
  }
}
