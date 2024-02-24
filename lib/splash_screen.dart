// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
// import 'package:trasheepartner/screens/shopkeeper/shop_approval_wait.dart';
// import 'package:trasheepartner/screens/shopkeeper/shop_details_add.dart';
// import 'package:trasheepartner/screens/shopkeeper/shop_homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hungerheavend/features/authentication/screens/login/login.dart';
import 'package:hungerheavend/features/authentication/screens/onboarding/onboarding.dart';
import 'package:hungerheavend/features/authentication/screens/rest_rt/signup_rest.dart';
import 'package:hungerheavend/navigation_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const String isRestaurantAdded = "added";
  static const String keylogin = "login";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/logos/hh.png',
                height: 380, // Increased height by 20%
                width: 380,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void whereToGo() async {
    var sharedPref = GetStorage();
    await sharedPref.initStorage;
    var isLogin = sharedPref.read(keylogin);
    var restaurantAdded = sharedPref.read(isRestaurantAdded) ?? false;

    debugPrint("""Let's print the bool values\n
    1) Is login: $isLogin\n
    2) Restaurant Added: $restaurantAdded""");

    Timer(
      const Duration(seconds: 3),
      () {
        if (isLogin != null) {
          if (isLogin && restaurantAdded) {
            Get.offAll(() =>const NavigationMenu());
          } else if (isLogin && !restaurantAdded) {
            Get.offAll(() => const RestSignUp());
          } else {
            Get.to(() => const LoginScreen());
          }
        } else {
          Get.offAll(() => const OnBoardingScreen());
        }
      },
    );
  }
}
