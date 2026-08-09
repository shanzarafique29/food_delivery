import 'package:flutter/material.dart';

class OrderWidgets {
  // Empty State Widget (Jab koi order na ho)
  static Widget buildEmptyOrders(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hit the orange button down below to Create an order',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Single Order Card Widget
  static Widget buildOrderCard({
    required String orderId,
    required String status,
    required String deliveryType,
    required double totalPrice,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$orderId',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4B3A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFFFF4B3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            'Delivery Type: $deliveryType',
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Rs ${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFFF4B3A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}