// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hungerheavend/navigation_menu.dart';
// import 'package:hungerheavend/splash_screen.dart';

// Future<void> addRestaurantDetails({
//   required String name,
//   required String address,
//   required String longitude,
//   required String latitude,
//   required String ownerId,
// }) async {
//   var sharedPref = GetStorage();
//   await sharedPref.initStorage;
//   try {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     var sharedPref = GetStorage();
//     await sharedPref.initStorage;
//     // Add data to rest_details collection
//     DocumentReference docRef = await firestore.collection("rest_details").add({
//       "name": name.trim(),
//       "address": address.trim(),
//       "longitude": longitude.trim(),
//       "latitude": latitude.trim(),
//       "ownerId": ownerId.trim(),
//     });
//     sharedPref.write("restaurantId", docRef.id);
//     await sharedPref.save();

//     await firestore.collection("rest_owners").doc(ownerId).update({
//       "isRestaurantAdded": true,
//     });

//     Fluttertoast.showToast(msg: "Signup Successful!");
//     sharedPref.write("restaurantAdded", true);
//     sharedPref.write(SplashScreenState.isRestaurantAdded, true);
//     Get.offAll(() => const NavigationMenu());
//   } catch (e) {
//     debugPrint("Error: $e");
//     Fluttertoast.showToast(msg: "Signup Failed!\nPlease try again later.");
//   }
// }
