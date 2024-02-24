import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hungerheavend/features/authentication/screens/login/login.dart';
import 'package:hungerheavend/utils/constants/image_strings.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';
import 'package:hungerheavend/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int randomCode = 0;
  bool isOtpVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    randomCode = Random().nextInt(9000) + 1000;
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    const String otpUrl =
        'https://syntaxium.in/DUSTBIN_API/hunger_haven_otp.php';
    setState(() {
      isLoading = true;
    });
    final sharedPref = GetStorage();

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };

      // Define request body
      Map<String, String> otpBody = {
        "email": sharedPref.read("signup_email"),
        "otp": randomCode.toString(),
      };
      // Use the http.post method with headers and body
      var response = await http.post(
        Uri.parse(otpUrl),
        headers: headers,
        body: otpBody,
      );
      var result = jsonDecode(response.body);
      debugPrint(response.body);
      bool er = result["error"];
      if (response.statusCode == 200 && er == false) {
        Fluttertoast.showToast(
          msg: result["message"],
        );
      } else {
        // Request failed
        Fluttertoast.showToast(
          msg: result["message"],
        );
        debugPrint('Error during otp: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network or other errors
      debugPrint('Error during otp: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyOtp() async {
    if (randomCode.toString() != otpController.text.toString()) {
      Fluttertoast.showToast(msg: "Incorrect Otp Entered");
      isOtpVerified = false;
    } else {
      isOtpVerified = true;
      _signup();
    }
  }

  void _signup() async {
    var sharedPref = GetStorage();
    sharedPref.initStorage;
    var user = <String, dynamic>{};
    user = {
      "fullname": sharedPref.read("signup_name").toString(),
      "email": sharedPref.read("signup_email").toString(),
      "phone": sharedPref.read("signup_phone").toString(),
      "isRestaurantAdded": false,
    };

    FirebaseFirestore db = FirebaseFirestore.instance;
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: sharedPref.read("signup_email"),
            password: sharedPref.read("signup_password"));
    debugPrint(credential.user.toString());
    DocumentReference doc = await db.collection("rest_owners").add(user);
    debugPrint("Verify Email Document id : ${doc.id}");
    Fluttertoast.showToast(msg: "Signup Success");
    Future.delayed(const Duration(seconds: 2));
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //image
              Image(
                height: 250,
                image: const AssetImage(TImages.deliveredEmailIllustration),
                width: THelperFunctions.screenWidth(),
              ),
              Text(
                TTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              Text(
                'hunger.haven@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              Text(
                TTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              Form(
                child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    labelText: "Otp",
                  ),
                  maxLength: 4,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      side: const BorderSide(color: Colors.amber)
                      ),
                  onPressed: (isLoading && isOtpVerified)
                      ? null
                      : () async {
                          verifyOtp();
                        },
                  child: const Text('Verify'),
                ),
              ),
              const SizedBox(height: 16),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
