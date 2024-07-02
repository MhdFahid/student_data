import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student/consts/constants.dart';
import 'package:student/screen/login.dart';
import 'package:student/suported_widgets/square_button.dart';
import 'package:student/controllers/registration_controller.dart';
import '../consts/app_color_constants.dart';
import '../suported_widgets/custom_text_field_with_button.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for the form validation

  final RegistrationController registrationController =
      Get.put(RegistrationController());

  RegistrationPage({super.key});

  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Age';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Address';
    }
    return null;
  }

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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColorsConstants.primaryColor,
                      ),
                    ),
                  ),
                  gapH(20),
                  CustomTextFieldWithButton(
                    controller: nameController,
                    hint: 'Name',
                    icon: Icons.person,
                    validator: validateName,
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
                    controller: addressController,
                    hint: 'Address',
                    icon: Icons.email,
                    validator: validateAddress,
                  ),
                  gapH(20),
                  CustomTextFieldWithButton(
                    controller: ageController,
                    hint: 'Age',
                    icon: Icons.email,
                    validator: validateAge,
                  ),
                  gapH(20),
                  CustomTextFieldWithButton(
                    controller: passwordController,
                    hint: 'New Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  gapH(20),
                  CustomTextFieldWithButton(
                    controller: confirmPasswordController,
                    hint: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: validateConfirmPassword,
                  ),
                  gapH(20),
                  Obx(() {
                    return SquareButton(
                      text: 'Register',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await registrationController.registerUser(
                            nameController.text,
                            emailController.text,
                            addressController.text,
                            ageController.text,
                            passwordController.text,
                          );
                        }
                      },
                      active: registrationController.isLoading.value,
                    );
                  }),
                  gapH(20),
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginPage());
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColorsConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
