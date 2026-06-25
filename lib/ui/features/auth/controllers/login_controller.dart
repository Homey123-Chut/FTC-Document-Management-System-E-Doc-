import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/core/utils/validators.dart';
import 'package:e_doc_redo/ui/features/user/repositories_impl/user_repository_impl.dart';
import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/services/auth_service.dart';
import 'package:e_doc_redo/ui/features/auth/services/login_service.dart';
import 'package:e_doc_redo/ui/features/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginService service;

  LoginController({LoginService? service}) : service = service ?? LoginService(MockUserRepository());

  final loginState = AsyncValue<UserModel?>.init().obs;
  final hidePassword = true.obs;
  final rememberMe = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool get isLoading => loginState.value.state == AsyncValueState.loading;

  String? validateEmail(String? value) {
    final email = value ?? '';
    if (email.isEmpty) return 'បំពេញអ៊ីមែលរបស់អ្នក';
    if (!Validators.isValidEmail(email)) return 'បញ្ចូលអ៊ីមែលដែលត្រឹមត្រូវ';
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'បំពេញពាក្យសម្ងាត់របស់អ្នក';
    if (!Validators.isValidPassword(password)) {
      return 'ពាក្យសម្ងាត់ត្រូវមានយ៉ាងហោចណាស់ ៦ តួអក្សរ និងរួមបញ្ចូលលេខ និងសញ្ញាពិសេស';
    }
    return null;
  }

  Future<void> handleLogin() async {
    loginState.value = AsyncValue.loading();

    try {
      final user = await service.auth(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        Get.find<AuthService>().setUser(user);

        loginState.value = AsyncValue.success(user);
        Get.offAll(() => const MainScreen());
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        loginState.value = AsyncValue.error(
          'អ្នកបានបញ្ចូលអ៊ីមែល ឬ ពាក្យសម្ងាត់មិនត្រឹមត្រូវទេ',
        );
      }
    } catch (e) {
      loginState.value = AsyncValue.error(
        'មានបញ្ហាក្នុងការចូលគណនី: $e សូមព្យាយាមម្តងទៀត',
      );
    }
  }

  /// Validates the form and triggers login if valid.
  /// Called by the view — keeps form-key references out of the widget.
  Future<void> submitLogin(GlobalKey<FormState> formKey) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    await handleLogin();
  }

  void togglePasswordVisibility() => hidePassword.toggle();

  void setRememberMe(bool value) => rememberMe.value = value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
