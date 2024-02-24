import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungerheavend/features/authentication/screens/signup/signup.dart';
import 'package:hungerheavend/navigation_menu.dart';
import 'package:hungerheavend/splash_screen.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';

import '../../rest_rt/signup_rest.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return GetBuilder<TSignInController>(
      init: TSignInController(),
      builder: (controller) {
        return Form(
          key: controller.loginFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: emailController,
                validator: controller._validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.name,
                validator: controller._validatePassword,
                obscureText: !controller.passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check5),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(
                    icon: Icon(controller.passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Do you have not any acount ?',
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(const SignupScreen());
                    },
                    child: const Text('Sign Up here..'),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.isTrue
                        ? null
                        : () async {
                            if (controller.loginFormKey.currentState!
                                .validate()) {
                              await controller.signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: const BorderSide(color: Colors.amber)),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        );
      },
    );
  }
}

class TSignInController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  bool passwordVisible = false;

  String? _validateEmail(String? value) {
    if ((value == null || value.isEmpty)) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value == null || value.isEmpty)) {
      return 'Please enter your password';
    } else if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(value)) {
      return 'Password must have 8 characters and contain 1 Uppercase, Lowercase, Digit & Special Character.';
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final sharedPref = GetStorage();
      await sharedPref.initStorage;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      final userQuery = await FirebaseFirestore.instance
          .collection("rest_owners")
          .where("email", isEqualTo: credential.user?.email!.trim())
          .get();

      if (userQuery.docs.isNotEmpty) {
        final user = userQuery.docs.first.data();
        final userId = userQuery.docs.first.id;

        // Find the corresponding rest_details document
        final restDetailsQuery = await FirebaseFirestore.instance
            .collection("rest_details")
            .where("ownerId", isEqualTo: userId)
            .get();

        String? restaurantId;
        if (restDetailsQuery.docs.isNotEmpty) {
          // Found rest_details document, get the restaurantId
          restaurantId = restDetailsQuery.docs.first.id;
        }

        // Save user details and restaurantId
        sharedPref.write('isLogin', true);
        sharedPref.write(SplashScreenState.keylogin, true);
        sharedPref.write("userId", userId);
        sharedPref.write("name", user["fullname"]);
        sharedPref.write("email", user["email"]);
        sharedPref.write("phone", user["phone"]);
        sharedPref.write("rest_added", user["isRestaurantAdded"]);
        sharedPref.write('restaurantAdded', user["isRestaurantAdded"]);
        sharedPref.write(
            SplashScreenState.isRestaurantAdded, user["isRestaurantAdded"]);
        sharedPref.write("restaurantId", restaurantId); // Save the restaurantId
        Fluttertoast.showToast(msg: "Login Success");
        await sharedPref.save();

        if (sharedPref.read("restaurantAdded") == true ||
            sharedPref.read(SplashScreenState.isRestaurantAdded) == true) {
          Get.offAll(() => const NavigationMenu());
        } else {
          Get.to(() => const RestSignUp());
        }
      } else {
        debugPrint("User not found in Firestore");
        Fluttertoast.showToast(msg: "Invalid Email or Password!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email or Password!");
      debugPrint("Sign In Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update(); // Notify GetX that the state has changed
  }
}
