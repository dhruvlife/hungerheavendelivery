import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../login/login.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: clearAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logout.gif',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Logging Out...',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
          );
        } else {
          // After data is cleared, navigate to LoginScreen
          return const Scaffold();
        }
      },
    );
  }

  Future<void> clearAllData() async {
    FirebaseAuth.instance.signOut();
    final storage = GetStorage();
    await storage.erase();
    Fluttertoast.showToast(msg: "Logout Successful!");
    await Future.delayed(const Duration(seconds: 4)); // Wait for 2 seconds
    Get.offAll(() => const LoginScreen());
  }
}
 