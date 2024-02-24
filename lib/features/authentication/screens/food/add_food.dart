import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../controllers/Restaurant/add_food_controller.dart';

class Addfood extends StatefulWidget {
  const Addfood({super.key});

  @override
  AddfoodState createState() => AddfoodState();
}

class AddfoodState extends State<Addfood> {
  File? productPhoto;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _addFoodKey = GlobalKey<FormState>();
  TextEditingController foodName = TextEditingController();
  TextEditingController foodCat = TextEditingController();
  var isProcessing = false.obs;

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    _handleImageSelection(image);
  }

  Future<void> _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    _handleImageSelection(image);
  }

  void _handleImageSelection(XFile? image) {
    if (image != null) {
      setState(() {
        productPhoto = File(image.path);
      });
    }
  }

  String? _validateFoodName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter food name';
    }
    return null;
  }

  String? _validateFoodCat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter food category';
    }
    return null;
  }

  Future<void> uploadPicture() async {
    if (_addFoodKey.currentState?.validate() ?? false) {
      var sharedPref = GetStorage();
      await sharedPref.initStorage;
      isProcessing(true);
      try {
        if (productPhoto != null) {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          String fileExtension =
              productPhoto!.path.split('.').last; // Get file extension
          String completeFileName =
              '$fileName.$fileExtension'; // Append extension to fileName

          Reference storageReference =
              _storage.ref().child('photos/').child(completeFileName);

          await storageReference.putFile(productPhoto!);

          String downloadURL = await storageReference.getDownloadURL();
          addFoodController(
              foodname: foodName.text,
              foodCat: foodCat.text,
              imagePath: downloadURL,
              restaurantId: sharedPref.read("restaurantId"));
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong\nTry Again in a few moments!");
        }
      } catch (e) {
        debugPrint('Firebase Storage Error: $e');
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
        title: const Text("Respect for you"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _addFoodKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: foodName,
                  validator: _validateFoodName,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.food_bank_rounded),
                    labelText: "Food Name",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: foodCat,
                  validator: _validateFoodCat,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    labelText: "Food Category",
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  'Upload Food Image...',style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                      backgroundColor:  Colors.indigo.shade200,
                      side: const BorderSide(color: Colors.deepPurple)
                      ),
                      onPressed: _takePicture,
                      child: const Text('Take Picture'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.teal.shade200,
                      side: const BorderSide(color: Colors.cyan)
                      ),
                      onPressed: _selectPicture,
                      child: const Text('Select Picture'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (productPhoto != null)
                  Image.file(
                    productPhoto!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 40),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                       style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 77, 237, 83),
                      side: const BorderSide(color: Colors.amber)
                      ),
                      onPressed: isProcessing.value ? null : uploadPicture,
                      child: isProcessing.value
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
