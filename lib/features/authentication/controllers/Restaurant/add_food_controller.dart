// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../navigation_menu.dart';

Future<void> addFoodController({
  required String foodname,
  required String imagePath,
  required String foodCat,
  required String restaurantId,
}) async {
  var sharedPref = GetStorage();
  await sharedPref.initStorage;
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Add data to rest_details collection
    DocumentReference docRef = await firestore.collection("food_details").add({
      "foodName": foodname.trim(),
      "foodCategory": foodCat.trim(),
      "imagePath": imagePath.trim(),
      "restaurantId": restaurantId.trim(),
      "status": "ongoing"
    });
    Fluttertoast.showToast(msg: "Donation Successful!");
    Get.offAll(() => const NavigationMenu());
  } catch (e) {
    debugPrint("Error: $e");
    Fluttertoast.showToast(msg: "Signup Failed!");
  }
}
