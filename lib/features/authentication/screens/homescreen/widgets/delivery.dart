
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:hungerheavend/utils/constants/sizes.dart';

// class Delivery extends StatefulWidget {
//   @override
//   _DeliveryState createState() => _DeliveryState();
// }

// class _DeliveryState extends State<Delivery> {
//   late TextEditingController _latitudeController;
//   late TextEditingController _longitudeController;

//   var isLoading = false.obs;

//   @override
//   void initState() {
//     super.initState();
//     _latitudeController = TextEditingController();
//     _longitudeController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     isLoading(true);
//     try {
//       Position? position;
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         throw 'Location services are disabled.';
//       }

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied) {
//           throw 'Location permissions are denied.';
//         }
//         if (permission == LocationPermission.deniedForever) {
//           throw 'Location permissions are permanently denied, we cannot request permission.';
//         }
//       }

//       position = await Geolocator.getCurrentPosition();
//       _latitudeController.text = position.latitude.toString();
//       _longitudeController.text = position.longitude.toString();

//     } catch (e) {
//       print('Error getting location: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Hey Easy Location"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: TSizes.spaceBtwSections,
//               ),
//               TextFormField(
//                 controller: _latitudeController,
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.location_add),
//                   labelText: "Latitude",
//                 ),
//               ),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems,
//               ),
//               TextFormField(
//                 controller: _longitudeController,
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.location),
//                   labelText: "Longitude",
//                 ),
//               ),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems,
//               ),
//               Obx(() {
//                 return SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: isLoading.value ? null : _getCurrentLocation,
//                     child: isLoading.value
//                         ? CircularProgressIndicator()
//                         : const Text('Current Location'),
//                   ),
//                 );
//               }),
//               const SizedBox(
//                 height: TSizes.spaceBtwSections,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add your submit logic here
//                   },
//                   child: const Text('Submit'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/*
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  var isLoading = false.obs;
  var isLocationStored = false.obs;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _getLocationFromFirebase();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    isLoading(true);
    try {
      Position? position;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
        if (permission == LocationPermission.deniedForever) {
          throw 'Location permissions are permanently denied, we cannot request permission.';
        }
      }

      position = await Geolocator.getCurrentPosition();
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
      await _storeLocationInFirebase(position.latitude, position.longitude);
      isLocationStored(true);
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _storeLocationInFirebase(double latitude, double longitude) async {
    final userId = ''; // Fetch user ID after authentication
    final userLocationRef = FirebaseFirestore.instance.collection('userLocations').doc(userId);

    await userLocationRef.set({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> _getLocationFromFirebase() async {
    final userId = ''; // Fetch user ID after authentication
    final userLocationRef = FirebaseFirestore.instance.collection('userLocations').doc(userId);

    final doc = await userLocationRef.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _latitudeController.text = data['latitude'].toString();
      _longitudeController.text = data['longitude'].toString();
      isLocationStored(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hey Easy Location"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location_add),
                  labelText: "Latitude",
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location),
                  labelText: "Longitude",
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isLoading.value ? null : _getCurrentLocation,
                    child: isLoading.value
                        ? CircularProgressIndicator()
                        : const Text('Current Location'),
                  ),
                );
              }),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your submit logic here
                  },
                  child: const Text('Submit'),
                ),
              ),
              Obx(() {
                return isLocationStored.value
                    ? Text('Location stored in Firebase!')
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  DeliveryState createState() => DeliveryState();
}

class DeliveryState extends State<Delivery> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  var isLoading = false.obs;
  var isLocationStored = false.obs;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _getLocationFromFirebase();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    isLoading(true);
    try {
      Position? position;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
        if (permission == LocationPermission.deniedForever) {
          throw 'Location permissions are permanently denied, we cannot request permission.';
        }
      }

      position = await Geolocator.getCurrentPosition();
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
      isLocationStored(false); // Reset location stored status
      isLocationStored(true); // Show location stored status
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _storeLocationInFirebase(double latitude, double longitude) async {
    try {
      const userId = ''; // Fetch user ID after authentication
      if (userId.isNotEmpty) {
        final userLocationRef = FirebaseFirestore.instance.collection('userLocations').doc(userId);

        await userLocationRef.set({
          'latitude': latitude,
          'longitude': longitude,
        });
      } else {
        throw 'User ID is empty.';
      }
    } catch (e) {
      debugPrint('Error storing location: $e');
    }
  }

  Future<void> _getLocationFromFirebase() async {
    try {
      const userId = ''; // Fetch user ID after authentication
      if (userId.isNotEmpty) {
        final userLocationRef = FirebaseFirestore.instance.collection('userLocations').doc(userId);

        final doc = await userLocationRef.get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _latitudeController.text = data['latitude'].toString();
          _longitudeController.text = data['longitude'].toString();
          isLocationStored(true);
        }
      } else {
        throw 'User ID is empty.';
      }
    } catch (e) {
      debugPrint('Error retrieving location: $e');
    }
  }

  Future<void> _submitLocation() async {
    final double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    final double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

    // Store location in Firebase
    await _storeLocationInFirebase(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hey Easy Location"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location_add),
                  labelText: "Latitude",
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location),
                  labelText: "Longitude",
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isLoading.value ? null : _getCurrentLocation,
                    child: isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Current Location'),
                  ),
                );
              }),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitLocation,
                  child: const Text('Submit'),
                ),
              ),
              Obx(() {
                return isLocationStored.value
                    ? const Text('Location stored in Firebase!')
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
