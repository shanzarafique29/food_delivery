import 'package:flutter/material.dart';

class CheckoutWidgets {
  // ============================================================
  // ADDRESS BOX
  // ============================================================

  static Widget buildAddressBox({
    required String name,
    required String address,
    required String phone,
    required VoidCallback onChangePressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              TextButton(
                onPressed: onChangePressed,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Color(0xFFFF4B3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const Divider(),

          const SizedBox(height: 5),

          Text(
            address,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            phone,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY METHOD
  // ============================================================

  static Widget buildDeliveryMethodBox({
    required String selectedMethod,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text(
              'Door delivery',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            value: 'Door delivery',
            groupValue: selectedMethod,
            activeColor: const Color(0xFFFF4B3A),
            onChanged: onChanged,
          ),

          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),

          RadioListTile<String>(
            title: const Text(
              'Pick up',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            value: 'Pick up',
            groupValue: selectedMethod,
            activeColor: const Color(0xFFFF4B3A),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}