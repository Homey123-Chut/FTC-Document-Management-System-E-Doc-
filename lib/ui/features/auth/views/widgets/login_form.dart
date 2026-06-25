import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/ui/features/auth/controllers/login_controller.dart';
import 'package:e_doc_redo/ui/features/auth/views/widgets/login_error_banner.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_doc_redo/core/theme/theme.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LoginController controller;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'ចូលប្រើប្រាស់',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Obx(() {
            final state = controller.loginState.value;
            if (state.state != AsyncValueState.error) {
              return const SizedBox.shrink();
            }
            return LoginErrorBanner(message: state.error.toString());
          }),

          TextFieldWidget(
            label: 'អ៊ីមែល',
            hintText: 'បញ្ចូលអ៊ីមែលរបស់អ្នក',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: controller.validateEmail,
          ),

          const SizedBox(height: 20),

          Obx(
            () => TextFieldWidget(
              label: 'ពាក្យសម្ងាត់',
              hintText: 'បញ្ចូលពាក្យសម្ងាត់របស់អ្នក',
              controller: controller.passwordController,
              obscureText: controller.hidePassword.value,
              textInputAction: TextInputAction.done,
              validator: controller.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.hidePassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.darkBlue,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),

          const SizedBox(height: 12),

          _RememberMeRow(controller: controller),

          const SizedBox(height: 24),

          Obx(
            () => ButtonWidget(
              text: 'ចូលប្រើប្រាស់',
              backgroundColor: AppColors.darkBlue,
              width: double.infinity,
              foregroundColor: AppColors.white,
              isLoading: controller.isLoading,
              onPressed: controller.isLoading
                  ? null
                  : () => controller.submitLogin(formKey),
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberMeRow extends StatelessWidget {
  final LoginController controller;
  const _RememberMeRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: controller.rememberMe.value,
                activeColor: AppColors.darkBlue,
                onChanged: (value) =>
                    controller.setRememberMe(value ?? false),
              ),
              const Text(
                'ចងចាំខ្ញុំ',
                style: TextStyle(color: AppColors.darkBlue, fontSize: 16),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'ភ្លេចពាក្យសម្ងាត់?',
              style: TextStyle(
                color: AppColors.darkBlue,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
