import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../assigned_orders/assigned_food_screen.dart';
import '../delivered_orders/delivered_food_screen.dart';

class HomeScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedPref = GetStorage();
    sharedPref.initStorage;
    String userId = sharedPref.read("userId") ?? "";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Home Screen"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Assigned'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AssignedFoodScreen(delivererId: userId),
            DeliveredFoodScreen(delivererId: userId),
          ],
        ),
      ),
    );
  }
}

class LocationController extends GetxController {
  Rx<Position?> userLocation = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  ).obs;

  StreamSubscription<Position>? positionStream;
  @override
  void onInit() {
    startListeningToPositionStream();
    super.onInit();
  }

  void startListeningToPositionStream() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
        msg: 'Location permissions are denied.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg:
            'Location permissions are permanently denied.\nPlease enable them in app settings.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      LocationSettings locationSettings;

      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Hunger Heaven is using your device location to send you the update of any order",
            notificationTitle: "Thank you for your service",
            enableWakeLock: true,
          ),
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        );
      }

      Timer.periodic(const Duration(seconds: 30), (timer) async {
        try {
          Position? position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          userLocation.value = position;
          await updateUserLocationInFirestore(position);
        } on LocationServiceDisabledException catch (e) {
          // Handle location service disabled exception
          print('LocationServiceDisabledException: $e');

          // Show toast message to inform the user
          Fluttertoast.showToast(
            msg: 'Please enable location services for the best experience.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      });
    }
  }

  // Future<void> startListeningToPositionStream() async {
  //   LocationPermission permission = await Geolocator.requestPermission();

  //   if (permission == LocationPermission.denied) {
  //     await requestLocationPermission();
  //   } else if (permission == LocationPermission.deniedForever) {
  //     showToast(
  //         'Location permissions are permanently denied.\nPlease enable them in app settings.');
  //   } else {
  //     LocationSettings locationSettings;

  //     if (defaultTargetPlatform == TargetPlatform.android) {
  //       locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 100,
  //         forceLocationManager: true,
  //         intervalDuration: const Duration(seconds: 10),
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //           notificationText:
  //               "Hunger Heaven is using your device location to send you the update of any order",
  //           notificationTitle: "Thank you for your service",
  //           enableWakeLock: true,
  //         ),
  //       );
  //     } else {
  //       locationSettings = const LocationSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 0,
  //       );
  //     }

  //     positionStream = Geolocator.getPositionStream(
  //       locationSettings: locationSettings,
  //     ).handleError((error) {
  //       handleLocationError(error);
  //     }).listen((Position? position) async {
  //       if (position != null) {
  //         userLocation.value = position;
  //         await updateUserLocationInFirestore(position);
  //       }
  //     });
  //   }
  // }

  Future<void> requestLocationPermission() async {
    bool granted = await showDialog(
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Please enable location permissions for the best experience.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );

    if (granted == true) {
      // User granted permission, restart the location stream
      startListeningToPositionStream();
    } else {
      showToast('Location permissions are denied.');
    }
  }

  void handleLocationError(dynamic error) {
    if (error is LocationServiceDisabledException) {
      // Location services are disabled, prompt user to enable them
      showToast(
          'Location services are disabled. Please enable them in device settings.');
      openLocationSettings();
    } else {
      // Handle other location-related errors here
      print('Location error: $error');
    }
  }

  void openLocationSettings() {
    Geolocator.openAppSettings();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> updateUserLocationInFirestore(Position location) async {
    var sharedPref = GetStorage();
    String userId = sharedPref.read("userId") ?? "";

    if (userId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('deliverer_details')
            .doc(userId)
            .update({
          'latitude': location.latitude.toString(),
          'longitude': location.longitude.toString(),
        });
        debugPrint("Updated in firebase");
      } catch (e) {
        debugPrint("Error updating user location in Firestore: $e");
      }
    }
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }
}
