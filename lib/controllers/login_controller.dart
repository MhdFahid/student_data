import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:student/screen/student_list_page.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => StudentListPage());
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;

        case 'user-not-found':
          message = 'No user found for the given email address.';
          break;

        default:
          message = 'An undefined error occurred.';
      }

      Get.showSnackbar(GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
