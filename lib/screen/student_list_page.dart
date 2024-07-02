// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:student/consts/constants.dart';
// ignore: unused_import
import 'package:student/screen/registration_screen.dart';
import '../consts/app_color_constants.dart';
import '../suported_widgets/card_item.dart';
import '../suported_widgets/download_button.dart';
import 'login.dart';
import 'pdf_view_screen.dart';

class StudentListPage extends StatelessWidget {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(247, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Student List',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(),
              child: InkWell(
                  onTap: () async {
                    Get.dialog(
                      Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Logout',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 25),
                              ),
                              const SizedBox(height: 20.0),
                              const SizedBox(
                                height: 2,
                                width: double.infinity,
                              ),
                              const SizedBox(height: 20.0),
                              const Text(
                                "Are you sure you want to Logout?",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 50.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Not now',
                                        style: TextStyle(
                                            color:
                                                AppColorsConstants.primaryColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  gapw(6),
                                  MaterialButton(
                                    color: AppColorsConstants.redColor,
                                    splashColor: AppColorsConstants.redColor,
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Get.offAllNamed('/register');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                            color:
                                                AppColorsConstants.whiteColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColorsConstants.redColor),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout_outlined, color: Colors.white),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ))),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: students.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return CardItem(document: document);
                    }).toList(),
                  ),
                ),
                const DownloadButton(
                  onTap: exportFile,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
