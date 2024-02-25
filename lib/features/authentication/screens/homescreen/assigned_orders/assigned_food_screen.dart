// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'package:shimmer/shimmer.dart';

// class AssignedFoodScreen extends StatelessWidget {
//   final String restaurantId;

//   const AssignedFoodScreen({super.key, required this.restaurantId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('food_details')
//             .where('restaurantId', isEqualTo: restaurantId)
//             .where('status', isEqualTo: 'assigned')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Show shimmer effect while loading
//             return _buildShimmerEffect();
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No assigned orders found.'),
//             );
//           } else {
//             // Data is loaded, build the UI
//             return _buildOngoingOrdersList(snapshot.data!.docs);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 5, // Number of shimmer items
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Container(
//               width: 56.0,
//               height: 56.0,
//               color: Colors.white,
//             ),
//             title: Container(
//               height: 16.0,
//               color: Colors.white,
//             ),
//             subtitle: Container(
//               height: 16.0,
//               color: Colors.white,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOngoingOrdersList(List<QueryDocumentSnapshot> documents) {
//     return ListView.builder(
//       itemCount: documents.length,
//       itemBuilder: (context, index) {
//         // Extract data from the document
//         String imageLink = documents[index]['imagePath'];
//         String itemName = documents[index]['foodName'];
//         String itemCat = documents[index]['foodCategory'];
//         String orderStatus = documents[index]['status'];

//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             elevation: 12,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             color: Colors.black,
//             child: Column(
//               children: [
//                 // ClipRRect(
//                 //   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                 //   child: Image.network(
//                 //     imageLink,
//                 //     width: Get.width * 0.95,
//                 //   ),
//                 // ),
//                 ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.95,
//                         height: Get.width * 0.6, // Adjust the height as needed
//                         child: Image.network(
//                           imageLink,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) {
//                               return child;
//                             }
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(Icons.error);
//                           },
//                         ),
//                       ),
//                       if (imageLink
//                           .isEmpty) // Show placeholder if image link is empty
//                         const Icon(Icons.image, size: 40),
//                     ],
//                   ),
//                 ),

//                 ListTile(
//                   title: Text(
//                     itemName.capitalize!,
//                     style: const TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: Text('Status: ${orderStatus.toUpperCase()}'),
//                   subtitle: Text(
//                     itemCat.capitalize!,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shimmer/shimmer.dart';

class AssignedFoodScreen extends StatelessWidget {
  final String delivererId;

  const AssignedFoodScreen({super.key, required this.delivererId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_details')
            .where('deliveredId', isEqualTo: delivererId)
            .where('status', isEqualTo: 'assigned')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show shimmer effect while loading
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No assigned orders found.'),
            );
          } else {
            // Data is loaded, build the UI
            return _buildAssignedOrdersList(snapshot.data!.docs);
          }
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Number of shimmer items
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 56.0,
              height: 56.0,
              color: Colors.white,
            ),
            title: Container(
              height: 16.0,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignedOrdersList(List<QueryDocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        // Extract data from the document
        String imageLink = documents[index]['imagePath'];
        String itemName = documents[index]['foodName'];
        String itemCat = documents[index]['foodCategory'];
        String orderStatus = documents[index]['status'];
        String restaurantId = documents[index]['restaurantId'];

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('rest_details')
              .doc(restaurantId)
              .get(),
          builder: (context, restaurantSnapshot) {
            if (restaurantSnapshot.connectionState ==
                ConnectionState.waiting) {
              // Show a loading indicator while fetching restaurant details
              return const CircularProgressIndicator();
            } else if (restaurantSnapshot.hasError) {
              return Center(
                child: Text('Error: ${restaurantSnapshot.error}'),
              );
            } else if (!restaurantSnapshot.hasData) {
              return const Center(
                child: Text('Restaurant details not found.'),
              );
            } else {
              // Data is loaded, build the UI
              String restaurantName =
                  restaurantSnapshot.data!['name'].toString();
              String restaurantAddress =
                  restaurantSnapshot.data!['address'].toString();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.black,
                  child: Column(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Get.width * 0.95,
                              height: Get.width * 0.6,
                              child: Image.network(
                                imageLink,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            if (imageLink
                                .isEmpty) // Show placeholder if image link is empty
                              const Icon(Icons.image, size: 40),
                          ],
                        ),
                      ),

                      // Order details
                      ListTile(
                        title: Text(
                          itemName.capitalize!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing:
                            Text('Status: ${orderStatus.toUpperCase()}'),
                        subtitle: Text(
                          itemCat.capitalize!,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      // Restaurant details
                      ListTile(
                        title: Text(
                          'Restaurant Name: $restaurantName',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Restaurant Address: $restaurantAddress',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
  
}


