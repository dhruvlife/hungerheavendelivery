import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final RxBool isProcessing = false.obs;
  final RxBool resetSuccessful = false.obs;

  ResetPasswordScreen({super.key});

  Future<void> resetPassword() async {
    try {
      isProcessing.value = true;
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: 'Password Reset Mail Send Successfully to your email');
      resetSuccessful.value = true;
    } catch (e) {
      resetSuccessful.value = false;
      Fluttertoast.showToast(msg: 'Failed to send reset email: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
                  onPressed: isProcessing.value
                      ? null
                      : () {
                          resetPassword();
                        },
                  child: isProcessing.value
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                )),
            const SizedBox(height: 16),
            Obx(() {
              if (resetSuccessful.value) {
                return Text(
                  'Reset email sent successfully to ${emailController.text.trim()}',
                  style: const TextStyle(color: Colors.green),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
