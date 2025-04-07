import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:unstudio_ai/common/app_button.dart';
import 'package:unstudio_ai/common/app_text_field.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/controllers/auth_controller.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';
import 'package:get/get.dart';
import 'package:unstudio_ai/utils/base_validator.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signUpFormKey,
      child: Scaffold(
        backgroundColor: AppColors.appWhiteColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.1,
            horizontal: 38,
          ),
          child: Column(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: AppTextStyles(context).display20W700,
              ),
              30.0.toVSB,
              buildAppUnitTextField(
                context,
                'Name:',
                controller.nameController,
                validator: Validator.validateName,
              ),
              buildAppUnitTextField(
                context,
                'Email:',
                controller.emailController,
                validator: Validator.validateEmail,
              ),
              buildAppUnitTextField(
                context,
                'Password:',
                controller.passController,
                obscureText: true,
                validator: Validator.validatePassword,
              ),
              const Spacer(),
              Column(
                children: [
                  Obx(
                    () => AppButton(
                      text: 'Next',
                      buttonColor: AppColors.grayLight,
                      textColor: AppColors.black,
                      width: Get.width * 0.7,
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        if (controller.signUpFormKey.currentState!.validate()) {
                          controller.signUpWithEmail();
                        }
                      },
                    ),
                  ),
                  10.0.toVSB,
                  Text(
                    'Skip',
                    style: AppTextStyles(context).display16W500.copyWith(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ],
              ),
              20.0.toVSB,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppUnitTextField(
    BuildContext context,
    String title,
    TextEditingController controller, {
    String? hintText,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles(context).display16W400),
        5.0.toVSB,
        AppTextField(
          hintText: hintText,
          controller: controller,
          validator: validator,
          obscureText: obscureText ?? false,
        ),
      ],
    );
  }
}
