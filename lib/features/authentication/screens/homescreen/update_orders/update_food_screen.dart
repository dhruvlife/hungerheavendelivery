import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hungerheavend/features/authentication/screens/homescreen/widgets/home_screen_form.dart';
import 'package:hungerheavend/navigation_menu.dart';

class UpdateFoodScreen extends StatefulWidget {
  const UpdateFoodScreen({super.key});

  @override
  UpdateFoodScreenState createState() => UpdateFoodScreenState();
}

class UpdateFoodScreenState extends State<UpdateFoodScreen> {
  final RxString selectedItemId = "".obs;
  final RxBool isProcessing = false.obs;

  @override
  Widget build(BuildContext context) {
    var sharedPref = GetStorage();
    sharedPref.initStorage;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Food Status"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('food_details')
                      .where('delivererId', isEqualTo: sharedPref.read("userId"))
                      .where('status', isEqualTo: 'assigned')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
            
                    List<DocumentSnapshot> items = snapshot.data!.docs;
            
                    return DropdownButton<DocumentSnapshot>(
                      value: selectedItemId.value.isNotEmpty
                          ? items.firstWhere(
                              (item) => item.id == selectedItemId.value,
                            )
                          : items[0],
                      items: items
                          .map((item) => DropdownMenuItem<DocumentSnapshot>(
                                value: item,
                                child: Text(
                                    "${item['foodName']} - ${item['foodCategory']}"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedItemId.value = value!.id;
                        });
                      },
                      hint: const Text("Select Item"),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (selectedItemId.value.isEmpty) {
                    return const Text("Select an item to view details");
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('food_details')
                              .doc(selectedItemId.value)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Food Name: ${data['foodName']}"),
                                Text("Food Category: ${data['foodCategory']}"),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isProcessing.value ? null : () => _updateStatus(),
                  child: const Text("Update Status"),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (isProcessing.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus() async {
    isProcessing.value = true;

    try {
      await FirebaseFirestore.instance
          .collection('food_details')
          .doc(selectedItemId.value)
          .update({'status': 'delivered'});
      Fluttertoast.showToast(
        msg: 'Order Delivered and status updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Get.to(() => const NavigationMenu());
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Fail to update the delivery status!\nTry again after some time!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Get.to(() => const NavigationMenu());
    } finally {
      isProcessing.value = false;
    }
  }
}
