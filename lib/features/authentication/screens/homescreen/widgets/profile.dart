import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hungerheavend/features/authentication/screens/logout/logout_screen.dart';
import 'package:hungerheavend/myuihelper.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phone = TextEditingController();
    String userId = "";
    var sharedPref = GetStorage();
    sharedPref.initStorage;
    name.text = sharedPref.read("name") ?? 'Hunger Heaven';
    email.text = sharedPref.read("email") ?? 'hunger.heaven@gmail.com';
    phone.text = sharedPref.read("phone") ?? '1234567890';
    userId = sharedPref.read("userId") ?? '12345678901234567890';
    Future<void> updateUserData(
        String userId, Map<String, dynamic> updatedData) async {
      try {
        await FirebaseFirestore.instance
            .collection("rest_owners")
            .doc(userId)
            .update(updatedData);
        sharedPref.write("name", name.text);
        sharedPref.write("email", email.text);
        sharedPref.write("phone", phone.text);
        Fluttertoast.showToast(msg: "Details Updated SuccessFully");
      } catch (e) {
        Fluttertoast.showToast(msg: "Error while updating your details");
        debugPrint("Error updating user data: $e");
        // Handle the error accordingly
      }
    }

    void updateUserInfo(String userId) {
      Map<String, dynamic> updatedData = {
        "fullname": name.text,
        "email": email.text,
        "phone": phone.text,
      };
      updateUserData(userId, updatedData);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          //key: loginFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  TextFormField(
                    //validator: _validateEmail,
                    controller: name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: "Full Name",
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwInputFields,
                  ),
                  TextFormField(
                    //validator: _validateEmail,
                    controller: email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwInputFields,
                  ),
                  TextFormField(
                    //validator: _validateEmail,
                    // initialValue: ,
                    controller: phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_android_rounded),
                      labelText: 'Phone Number',
                    ),
                  ), 
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      side: const BorderSide(color: Colors.greenAccent)
                      ),
                      onPressed: () {
                        updateUserInfo(userId);
                      },
                      child: const Text('Update Profile'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        DUI.CustomAlertBox(context, "Logout proccessing");
                      },
                     style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.amber)
                      ),
                      child: const Text(
                        "Logout",
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
