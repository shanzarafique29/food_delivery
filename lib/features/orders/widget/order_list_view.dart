import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/features/home/view/homescreen.dart';
import 'package:food_delivery/features/orders/controller/order_controller.dart';
import 'package:food_delivery/features/orders/widget/cancel_order_dialog.dart';
import 'package:food_delivery/features/orders/widget/order_widget.dart';
import 'package:get/get.dart';

class OrderListView extends StatelessWidget {
  final List<String> statuses;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  const OrderListView({
    super.key,
    required this.statuses,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.getUserOrders(statuses: statuses),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF4B3A)),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Unable to load orders:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        final docs = (snapshot.data?.docs ?? [])
            .where((doc) => doc.data()['hiddenByUser'] != true)
            .toList();
        if (docs.isEmpty) {
          return OrderWidgets.buildEmptyOrders(
            context,
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: 'Hit the orange button down below to Create an order',
            onStartOrdering: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          );
        }

        return RefreshIndicator(
          color: Color(0xFFFF4B3A),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final totalPrice = _toDouble(
                data['totalPrice'] ?? data['totalAmount'] ?? data['grandTotal'],
              );
              final status = (data['status']?.toString().isNotEmpty ?? false)
                  ? data['status'].toString()
                  : 'Pending';
              final deliveryType =
                  (data['deliveryType']?.toString().isNotEmpty ?? false)
                  ? data['deliveryType'].toString()
                  : (data['deliveryOption']?.toString() ?? 'Door delivery');
              final shortId = doc.id.length >= 6
                  ? doc.id.substring(0, 6)
                  : doc.id;
              final cancelRequestStatus = data['cancelRequestStatus']
                  ?.toString();
              final items = (data['items'] as List<dynamic>? ?? [])
                  .map((e) => Map<String, dynamic>.from(e as Map))
                  .toList();
              final paymentVerificationStatus =
                  data['paymentVerificationStatus']?.toString();
              return OrderWidgets.buildOrderCard(
                orderId: shortId,
                status: status,
                deliveryType: deliveryType,
                totalPrice: totalPrice,
                items: items,
                cancelRequestStatus: cancelRequestStatus,
                paymentVerificationStatus: paymentVerificationStatus,

                onCancelPressed:
                    (status == 'Delivered' || status == 'Cancelled')
                    ? null
                    : () => showDialog(
                        context: context,
                        builder: (_) => CancelOrderDialog(
                          orderId: doc.id,
                          controller: controller,
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
