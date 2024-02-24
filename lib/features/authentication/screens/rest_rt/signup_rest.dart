// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import '../../controllers/Restaurant/restaurant_controller.dart';

class RestSignUp extends StatefulWidget {
  const RestSignUp({super.key});

  @override
  RestSignUpState createState() => RestSignUpState();
}

class RestSignUpState extends State<RestSignUp> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  TextEditingController rest_name = TextEditingController();
  TextEditingController rest_address = TextEditingController();

  var isLoading = false.obs;
  var isLocationStored = false.obs;
  var isProcessing = false.obs;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    rest_address.dispose();
    rest_name.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    isLoading(true);
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
      msg: 'Location permissions are permanently denied.\nPlease enable them in app settings.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        isProcessing(true);
        var sharedPref = GetStorage();
        await sharedPref.initStorage;
        await addRestaurantDetails(
          name: rest_name.text,
          address: rest_address.text,
          latitude: _latitudeController.text,
          longitude: _longitudeController.text,
          ownerId: sharedPref.read("userId"),
        );
      } finally {
        isProcessing(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Restaurant Detail"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.sm),
              Text(
                'Restaurant Detail',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: rest_name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the restaurant name';
                  } else if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
                    return 'Please enter a valid name format';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                minLines: 3,
                maxLines: 5,
                controller: rest_address,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the restaurant address';
                  } else if (value.length < 50) {
                    return 'Address must be at least 50 characters';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Restaurant Address',
                  prefixIcon: Icon(Icons.add_business_rounded),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                readOnly: true,
                controller: _latitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the latitude';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location_add),
                  labelText: "Latitude",
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TextFormField(
                readOnly: true,
                controller: _longitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the longitude';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.location),
                  labelText: "Longitude",
                ),
              ),
              const SizedBox(height: 30),
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
                  onPressed: isProcessing.value ? null : _submitForm,
                  child: isProcessing.value
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
