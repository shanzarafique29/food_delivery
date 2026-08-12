// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:food_delivery/features/orders/widget/order_widget.dart';
// import 'controller/order_controller.dart';


// class OrderScreen extends StatelessWidget {
//   const OrderScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final OrderController _orderController = OrderController();
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F8),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Orders',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: user == null
//           ? const Center(child: Text('Please login to view orders'))
//           : StreamBuilder(
//               stream: _orderController.getUserOrders(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Color(0xFFFF4B3A)),
//                   );
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return OrderWidgets.buildEmptyOrders(context);
//                 }

//                 final orderDocs = snapshot.data!.docs;

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: orderDocs.length,
//                   itemBuilder: (context, index) {
//                     final orderData = orderDocs[index].data() as Map<String, dynamic>;
//                     final totalPrice = (orderData['totalPrice'] ?? 0).toDouble();
//                     final status = orderData['status'] ?? 'Processing';
//                     final deliveryType = orderData['deliveryType'] ?? 'Door delivery';
//                     final shortId = orderDocs[index].id.substring(0, 6);

//                     return OrderWidgets.buildOrderCard(
//                       orderId: shortId,
//                       status: status,
//                       deliveryType: deliveryType,
//                       totalPrice: totalPrice,
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/features/orders/widget/order_widget.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'controller/order_controller.dart';

class OrderScreen extends StatelessWidget {
  final ProductModel? product;
  final OfferModel? offer;

  const OrderScreen({
    super.key,
    this.product,
    this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = OrderController();
    final user = FirebaseAuth.instance.currentUser;

    // Calculate discounted price if product is passed
    double originalPrice = product?.price ?? 0.0;
    double finalPrice = originalPrice;
    if (offer != null) {
      finalPrice = originalPrice * (1 - (offer!.discountPercent / 100));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product != null ? 'Checkout' : 'Orders',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: product != null
          ? _buildSingleItemCheckout(context, originalPrice, finalPrice)
          : _buildOrdersList(orderController, user),
    );
  }

  // View 1: When navigating from Product Detail Screen
  Widget _buildSingleItemCheckout(
      BuildContext context, double originalPrice, double finalPrice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (offer != null) ...[
                    Row(
                      children: [
                        Text(
                          "Rs. ${originalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Rs. ${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFF4B3A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Promo Applied: ${offer!.code} (${offer!.discountPercent}% OFF)",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "Rs. ${originalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4B3A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // TODO: Call your place order method from orderController
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order Placed Successfully!')),
                );
              },
              child: Text(
                "Place Order (Rs. ${finalPrice.toStringAsFixed(2)})",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // View 2: When opening past Order History
  Widget _buildOrdersList(OrderController orderController, User? user) {
    if (user == null) {
      return const Center(child: Text('Please login to view orders'));
    }

    return StreamBuilder(
      stream: orderController.getUserOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF4B3A)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return OrderWidgets.buildEmptyOrders(context);
        }

        final orderDocs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderDocs.length,
          itemBuilder: (context, index) {
            final orderData =
                orderDocs[index].data() as Map<String, dynamic>;
            final totalPrice =
                (orderData['totalPrice'] ?? 0).toDouble();
            final status = orderData['status'] ?? 'Processing';
            final deliveryType =
                orderData['deliveryType'] ?? 'Door delivery';
            final shortId = orderDocs[index].id.length >= 6
                ? orderDocs[index].id.substring(0, 6)
                : orderDocs[index].id;

            return OrderWidgets.buildOrderCard(
              orderId: shortId,
              status: status,
              deliveryType: deliveryType,
              totalPrice: totalPrice,
            );
          },
        );
      },
    );
  }
}