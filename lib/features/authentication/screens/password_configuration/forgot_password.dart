import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final RxBool isProcessing = false.obs;

  ForgotPasswordScreen({super.key});

  Future<void> resetPassword() async {
    try {
      isProcessing.value = true;
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: 'Password reset email sent to ${emailController.text.trim()}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send the password link $e');
    } finally {
      isProcessing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: isProcessing.value ? null : resetPassword,
                  child: isProcessing.value
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                )),
          ],
        ),
      ),
    );
  }
}
