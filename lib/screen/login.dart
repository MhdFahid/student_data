import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student/consts/app_color_constants.dart';
import 'package:student/consts/constants.dart';
import 'package:student/controllers/login_controller.dart';
import 'package:student/suported_widgets/custom_text_field_with_button.dart';
import '../suported_widgets/square_button.dart';
import 'registration_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>(); // Key for the form validation

  LoginPage({super.key});

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColorsConstants.primaryColor,
                  ),
                ),
              ),
              gapH(20),
              CustomTextFieldWithButton(
                controller: emailController,
                hint: 'Email address',
                icon: Icons.email,
                validator: validateEmail,
              ),
              gapH(20),
              CustomTextFieldWithButton(
                controller: passwordController,
                hint: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: validatePassword,
              ),
              gapH(20),
              Obx(() {
                return SquareButton(
                  text: 'Login',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await loginController.loginUser(
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                  active: loginController.isLoading.value,
                );
              }),
              gapH(20),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColorsConstants.primaryColor,
                ),
              ),
              gapH(20),
              SquareButton(
                textColor: AppColorsConstants.primaryColor,
                bgColor: const Color.fromARGB(241, 246, 242, 242),
                text: 'Register',
                onTap: () {
                  Get.to(() => RegistrationPage());
                },
                active: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
