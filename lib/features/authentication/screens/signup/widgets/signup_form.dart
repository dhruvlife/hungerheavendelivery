import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hungerheavend/common/widgets/login_signup/form_divider.dart';
import 'package:hungerheavend/common/widgets/login_signup/social_icon.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';

import '../verify_email.dart';

class TSignUpForm extends StatefulWidget {
  const TSignUpForm({Key? key}) : super(key: key);

  @override
  TSignUpFormState createState() => TSignUpFormState();
}

class TSignUpFormState extends State<TSignUpForm> {
  late TSignUpController controller;

  @override
  void initState() {
    super.initState();
    controller = TSignUpController();
    controller._latitudeController = TextEditingController();
    controller._longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    controller._latitudeController.dispose();
    controller._longitudeController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    controller.isLoading(true);
    try {
      Position? position;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await _showLocationServiceDisabledToast();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          await _showLocationPermissionDeniedToast();
          return;
        }
        if (permission == LocationPermission.deniedForever) {
          await _showLocationPermissionPermanentlyDeniedToast();
          return;
        }
      }
      position = await Geolocator.getCurrentPosition();
      controller._latitudeController.text = position.latitude.toString();
      controller._longitudeController.text = position.longitude.toString();
      controller.isLocationStored(true);
      controller.hasProvidedLocation(true);
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      controller.isLoading(false);
    }
  }

  Future<void> _showLocationServiceDisabledToast() async {
    Fluttertoast.showToast(
      msg: 'Location services are disabled.\nPlease enable them to continue!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _showLocationPermissionDeniedToast() async {
    Fluttertoast.showToast(
      msg: 'Location permissions are denied.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _showLocationPermissionPermanentlyDeniedToast() async {
    Fluttertoast.showToast(
      msg:
          'Location permissions are permanently denied.\nPlease enable them in app settings.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TSignUpController>(
      init: controller,
      builder: (_) {
        return Form(
          key: controller.signupFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.fullName,
                validator: controller._validateName,
                textCapitalization: TextCapitalization.words,
                expands: false,
                decoration: const InputDecoration(
                  labelText: TTexts.fullName,
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: controller.emailAddress,
                validator: controller._validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: controller.phoneNo,
                validator: controller._validatePhone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: TTexts.phoneNo,
                  prefixIcon: Icon(Iconsax.call),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: controller._latitudeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Press the current location button';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.location_add),
                        labelText: "Latitude",
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: controller._longitudeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Press the current location button';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.location_add),
                        labelText: "Longitude",
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: controller.password,
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
              const SizedBox(height: TSizes.spaceBtwSections),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400
                    ),
                    onPressed:
                        controller.isLoading.value ? null : _getCurrentLocation,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Current Location'),
                  ),
                );
              }),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                    side: const BorderSide(color: Colors.amber),
                  ),
                  onPressed: () async {
                    if (controller.isProcessing) return;

                    bool isValid = controller.validateForm();
                    if (isValid) {
                      await controller.signup();
                    }
                  },
                  child: controller.isProcessing
                      ? const CircularProgressIndicator()
                      : const Text(TTexts.createAccount),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TFormDivider(
                dividerText: TTexts.orSignUpWith,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TSocialicon(),
            ],
          ),
        );
      },
    );
  }
}

class TSignUpController extends GetxController {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool isProcessing = false;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  var isLoading = false.obs;
  var isLocationStored = false.obs;
  var hasProvidedLocation = false.obs;
  dynamic db = FirebaseFirestore.instance;

  String? _validateEmail(String? value) {
    if ((value == null || value.isEmpty)) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$')
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
      return 'Password must be have 8 character and contains 1 Uppercase, LowerCase, Digit & Special Character.';
    }
    return null;
  }

  String? _validateName(String? value) {
    if ((value == null || value.isEmpty)) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z]+ [a-zA-Z]+$').hasMatch(value)) {
      return 'Please enter your name in the format "First Last"';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if ((value == null || value.isEmpty)) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number\nstarting with 6-9';
    }
    return null;
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update(); // Notify GetX that the state has changed
  }

  bool validateForm() {
    if (signupFormKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  Future<void> signup() async {
    try {
      // Check if the email or phone number already exists
      QuerySnapshot emailQuery = await db
          .collection("deliverer_details")
          .where("email", isEqualTo: emailAddress.text.trim())
          .get();

      QuerySnapshot phoneQuery = await db
          .collection("deliverer_details")
          .where("phone", isEqualTo: phoneNo.text.trim())
          .get();

      if (emailQuery.docs.isNotEmpty || phoneQuery.docs.isNotEmpty) {
        Fluttertoast.showToast(msg: "Email Or Phone Number Already Registered");
        return;
      } else {
        final sharedPref = GetStorage();
        sharedPref.write("signup_name", fullName.text.trim());
        sharedPref.write("signup_email", emailAddress.text.trim());
        sharedPref.write("signup_phone", phoneNo.text.trim());
        sharedPref.write("signup_latitude", _latitudeController.text.trim());
        sharedPref.write("signup_longitude", _longitudeController.text.trim());
        sharedPref.write("signup_password", password.text.trim());
        Get.offAll(() => const VerifyEmailScreen());
      }

      isProcessing = false;
      update();
    } catch (e) {
      debugPrint("Error: $e");
      isProcessing = false;
      update();
    }
  }
}
