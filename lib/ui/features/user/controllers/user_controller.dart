import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/ui/features/user/repository_impl/user_repository_impl.dart';
import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/controllers/auth_service.dart';
import 'package:e_doc_redo/ui/features/user/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final ProfileService service;

  UserController({ProfileService? service}) : service = service ?? ProfileService(MockUserRepository());
 
  final profileState = AsyncValue<UserModel?>.init().obs;
  final saveState = AsyncValue<void>.init().obs;
  final passwordState = AsyncValue<bool>.init().obs;
  final isEditing = false.obs;

  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? departmentController;
  String selectedGender = '';

  UserModel? get currentProfile => profileState.value.data;
  bool get isLoading => profileState.value.state == AsyncValueState.loading;
  bool get isSaving => saveState.value.state == AsyncValueState.loading;

  String get userId {
    final auth = Get.find<AuthService>();
    return auth.currentUser?.id ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    _loadFromSession();
  }

  void _loadFromSession() {
    final user = Get.find<AuthService>().currentUser;
    if (user != null) {
      profileState.value = AsyncValue.success(user);
    }
  }

  Future<void> fetchProfile(String id) async {
    profileState.value = AsyncValue.loading();
    try {
      final user = await service.getProfileById(id);
      if (user != null) {
        Get.find<AuthService>().setUser(user);
        profileState.value = AsyncValue.success(user);
      } else {
        profileState.value = AsyncValue.error('User not found');
      }
    } catch (e) {
      profileState.value = AsyncValue.error(e.toString());
    }
  }

  void toggleEdit() {
    if (isEditing.value) {

      _disposeFormControllers();
      isEditing.value = false;
    } else {

      final profile = currentProfile;
      if (profile != null) {
        usernameController = TextEditingController(text: profile.username);
        emailController = TextEditingController(text: profile.email);
        phoneController = TextEditingController(text: profile.phoneNumber);
        departmentController = TextEditingController(text: profile.department);
        selectedGender = profile.gender;
      }
      isEditing.value = true;
    }
  }

  Future<void> saveProfile() async {
    final profile = currentProfile;
    if (profile == null) return;

    saveState.value = AsyncValue.loading();

    try {
      final updated = profile.copyWith(
        username: usernameController?.text.trim() ?? profile.username,
        email: emailController?.text.trim() ?? profile.email,
        phoneNumber: phoneController?.text.trim() ?? profile.phoneNumber,
        gender: selectedGender,
        department: departmentController?.text.trim() ?? profile.department,
      );

      final result = await service.updateProfile(updated);
      if (result != null) {
        Get.find<AuthService>().setUser(result);
        profileState.value = AsyncValue.success(result);
        saveState.value = AsyncValue.success(null);
        _disposeFormControllers();
        isEditing.value = false;
      } else {
        saveState.value = AsyncValue.error('Failed to update profile');
      }
    } catch (e) {
      saveState.value = AsyncValue.error(e.toString());
    }
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    passwordState.value = AsyncValue.loading();

    try {
      final success = await service.changePassword(
        userId,
        oldPassword,
        newPassword,
      );
      if (success) {
        passwordState.value = AsyncValue.success(true);
      } else {
        passwordState.value = AsyncValue.error('Old password is incorrect');
      }
    } catch (e) {
      passwordState.value = AsyncValue.error(e.toString());
    }
  }

  void clearPasswordState() {
    passwordState.value = AsyncValue.init();
  }

  void _disposeFormControllers() {
    usernameController?.dispose();
    emailController?.dispose();
    phoneController?.dispose();
    departmentController?.dispose();
  }

  @override
  void onClose() {
    _disposeFormControllers();
    super.onClose();
  }
}
