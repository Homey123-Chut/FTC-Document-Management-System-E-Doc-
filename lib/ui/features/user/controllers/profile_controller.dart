import 'dart:convert';

import 'package:e_doc_redo/ui/features/user/repositories_impl/user_repository_impl.dart';
import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/services/auth_service.dart';
import 'package:e_doc_redo/ui/features/user/services/profile_service.dart';
import 'package:e_doc_redo/ui/features/welcome/welcome_screen.dart';
import 'package:e_doc_redo/ui/widgets/notification/message_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static const _entityAssetPath = 'lib/data/mock_data/level_workflow.json';

  static const List<String> roleItems = [
    'ប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល',
    'អនុប្រធាននាយកដ្ឋាន ឬ មជ្ឈមណ្ឌល',
    'ប្រធានការិយាល័យ',
    'អនុប្រធានការិយាល័យ',
    'មន្រ្តី',
    'អ្នកគ្រប់គ្រងប្រព័ន្ធ',
  ];

  final ProfileService _profileService;

  ProfileController({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService(MockUserRepository());

  final user = Rxn<UserModel>();
  final loading = false.obs;
  final hasError = false.obs;

  final isEditing = false.obs;
  final isSaving = false.obs;
  final editGender = ''.obs;
  final editEntity = ''.obs;
  final editRole = ''.obs;
  final obscurePassword = true.obs;

  /// Entity items loaded from level_workflow.json.
  final entityItems = <String>[].obs;

  /// Tracks whether an image upload is in progress.
  final isUploadingImage = false.obs;

  /// The most recently picked image data URI (not yet persisted).
  final pendingImagePath = Rxn<String>();

  // ── Form controllers (owned by controller, used by widget) ──────────────

  final formKey = GlobalKey<FormState>();

  TextEditingController? _nameCtrl;
  TextEditingController? _emailCtrl;
  TextEditingController? _phoneCtrl;
  TextEditingController? _passwordCtrl;

  TextEditingController get nameCtrl => _nameCtrl!;
  TextEditingController get emailCtrl => _emailCtrl!;
  TextEditingController get phoneCtrl => _phoneCtrl!;
  TextEditingController get passwordCtrl => _passwordCtrl!;

  // ── Computed getters ────────────────────────────────────────────────────

  /// Returns the profile image URL, falling back to a default asset.
  String get profileImageUrl {
    if (pendingImagePath.value != null && pendingImagePath.value!.isNotEmpty) {
      return pendingImagePath.value!;
    }
    if (user.value != null && user.value!.profileImg.isNotEmpty) {
      return user.value!.profileImg;
    }
    return '';
  }

  /// Returns the Khmer role label based on the user role.
  String get roleLabel {
    final role = user.value?.role;
    if (role != null && role.trim().isNotEmpty) return role.trim();
    return 'បុគ្គលិក';
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    // Load entity items first so dropdown values match when initEditFields runs.
    await fetchEntities();
    await fetchActiveUserSession();
  }

  @override
  void onClose() {
    _disposeFormControllers();
    super.onClose();
  }

  // ── Profile data ────────────────────────────────────────────────────────

  /// Loads entity names from level_workflow.json for the entity dropdown.
  Future<void> fetchEntities() async {
    try {
      final jsonString = await rootBundle.loadString(_entityAssetPath);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final levels = decoded['levels_workflow'] as List<dynamic>? ?? [];
      entityItems.value = levels
          .map((l) => (l as Map<String, dynamic>)['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (_) {
      entityItems.value = [];
    }
  }

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
        auth.setUser(userModel);
        initEditFields();
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      loading.value = false;
    }
  }

  void updateProfilePicture(String newLocalAssetPath) {
    if (user.value != null) {
      user.value = user.value!.copyWith(profileImg: newLocalAssetPath);
    }
  }

  // ── Image upload ────────────────────────────────────────────────────────

  /// Opens the file picker for image selection, then uploads the picked image.
  Future<void> pickAndUploadImage() async {
    try {
      final imageUri = await _profileService.pickImage();
      if (imageUri == null || imageUri.isEmpty) return;

      pendingImagePath.value = imageUri;

      final auth = Get.find<AuthService>();
      final userId = auth.currentUser?.id;
      if (userId == null) return;

      isUploadingImage.value = true;

      final resultPath = await _profileService.uploadProfileImage(userId, imageUri);
      if (resultPath != null) {
        if (user.value != null) {
          user.value = user.value!.copyWith(profileImg: resultPath);
        }
      }
    } catch (e) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចបញ្ចូលរូបភាពបានទេ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
      pendingImagePath.value = null;
    }
  }

  // ── Edit profile ────────────────────────────────────────────────────────

  /// Initialises form controllers from the current user and enters edit mode.
  void initEditFields() {
    final u = user.value;
    if (u == null) return;

    _disposeFormControllers();

    _nameCtrl = TextEditingController(text: u.username);
    _emailCtrl = TextEditingController(text: u.email);
    _phoneCtrl = TextEditingController(text: u.phoneNumber);
    _passwordCtrl = TextEditingController(text: u.password);

    // Capitalize first letter so "male"/"female" → "Male"/"Female" to match dropdown items.
    final gender = u.gender;
    editGender.value = gender.isNotEmpty
        ? '${gender[0].toUpperCase()}${gender.substring(1)}'
        : '';

    editEntity.value = u.department.trim();
    editRole.value = u.role.trim();
  }

  void toggleEdit() {
    if (isEditing.value) {
      _disposeFormControllers();
      isEditing.value = false;
    } else {
      initEditFields();
      isEditing.value = true;
    }
  }

  /// Saves the profile using the current form-controller values.
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    final current = user.value;
    if (current == null) return;

    final updated = current.copyWith(
      username: _nameCtrl?.text.trim() ?? current.username,
      email: _emailCtrl?.text.trim() ?? current.email,
      phoneNumber: _phoneCtrl?.text.trim() ?? current.phoneNumber,
      password: _passwordCtrl?.text.trim() ?? current.password,
      department: editEntity.value.trim(),
      gender: editGender.value.trim(),
      role: editRole.value.trim(),
    );

    isSaving.value = true;
    try {
      final result = await _profileService.updateProfile(updated);
      if (result != null) {
        user.value = result;
        Get.find<AuthService>().setUser(result);
      }
      isEditing.value = false;
      _disposeFormControllers();
      Get.snackbar('ជោគជ័យ', 'ព័ត៌មានត្រូវបានរក្សាទុក',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('មានបញ្ហា', 'មិនអាចរក្សាទុកបានទេ: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  void _disposeFormControllers() {
    _nameCtrl?.dispose();
    _emailCtrl?.dispose();
    _phoneCtrl?.dispose();
    _passwordCtrl?.dispose();
    _nameCtrl = null;
    _emailCtrl = null;
    _phoneCtrl = null;
    _passwordCtrl = null;
  }

  // ── Logout ──────────────────────────────────────────────────────────────

  Future<void> logout() async {
  final confirmed = await Get.dialog<bool>(
    const MessageConfirmDialog(
      title: 'ចាកចេញ',
      message: 'តើអ្នកប្រាកដជាចង់ចាកចេញពីប្រព័ន្ធនេះមែនទេ?',
      cancelText: 'បោះបង់',
      confirmText: 'ចាកចេញ',
      icon: Icons.logout_rounded,
    ),
  );

  if (confirmed == true) {
    Get.find<AuthService>().logout();
    Get.offAll(() => const WelcomeScreen());
  }
}
}
