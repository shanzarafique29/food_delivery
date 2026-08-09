import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/features/orders/widget/order_widget.dart';
import 'controller/order_controller.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController _orderController = OrderController();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text('Please login to view orders'))
          : StreamBuilder(
              stream: _orderController.getUserOrders(),
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
                    final orderData = orderDocs[index].data() as Map<String, dynamic>;
                    final totalPrice = (orderData['totalPrice'] ?? 0).toDouble();
                    final status = orderData['status'] ?? 'Processing';
                    final deliveryType = orderData['deliveryType'] ?? 'Door delivery';
                    final shortId = orderDocs[index].id.substring(0, 6);

                    return OrderWidgets.buildOrderCard(
                      orderId: shortId,
                      status: status,
                      deliveryType: deliveryType,
                      totalPrice: totalPrice,
                    );
                  },
                );
              },
            ),
    );
  }
}