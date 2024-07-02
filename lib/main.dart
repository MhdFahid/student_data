import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:student/screen/login.dart';
import 'package:student/screen/registration_screen.dart';
import 'package:student/screen/student_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Info List',
      home: const AuthGate(),
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegistrationPage()),
        GetPage(name: '/home', page: () => StudentListPage()),
      ],
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          return StudentListPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
