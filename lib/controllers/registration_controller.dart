import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  var isLoading = false.obs;

  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  Future<void> registerUser(String name, String email, String address,
      String age, String password) async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await students.add({
        "name": name,
        "email": email,
        "address": address,
        "age": age,
        "id": students.id.toString(),
      });
      Get.offAllNamed('/home');
      Get.showSnackbar(const GetSnackBar(
        message: 'Registered successfully and logged in.',
        duration: Duration(seconds: 2),
      ));
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred.';

      if (e.code == 'email-already-in-use') {
        message = 'Email address is already in use';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'weak-password') {
        message = 'The password is not strong enough.';
      } else {
        message = 'Error: ${e.message}';
      }

      Get.showSnackbar(GetSnackBar(
        message: message.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
