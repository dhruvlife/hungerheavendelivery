import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hungerheavend/features/authentication/screens/logout/logout_screen.dart';

class DUI {
  static CustomTextField(TextEditingController controller, String text,
      IconData iconData, bool toHide) {
    return TextField(
      style: const TextStyle(color: Color.fromARGB(255, 71, 71, 71)),
      controller: controller,
      obscureText: toHide,
      obscuringCharacter: '#',
      decoration: InputDecoration(
        hintText: text,
        suffixIcon: Icon(iconData),
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 225,
      child: ElevatedButton(
        onPressed: () {
          voidCallback();
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 172, 172, 172),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  static Future<void> CustomAlertBox(BuildContext context, String text) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(240, 255, 255, 255),
          title: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 97, 6, 0),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAll(()=>const LogoutScreen());
                  },
                  
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
