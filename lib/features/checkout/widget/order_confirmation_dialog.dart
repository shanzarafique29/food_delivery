import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';

class OrderConfirmationDialog extends StatelessWidget {
  final String deliveryMethod;
  final List<Map<String, dynamic>> cartItems;
  final double Function(Map<String, dynamic>) getItemDeliveryFee;
  final double deliveryFee;
  final double promoDiscount;
  final String? promoCode;
  final String paymentMethodLabel;
  final double grandTotal;
  final bool isProcessing;
  final VoidCallback onConfirm;

  const OrderConfirmationDialog({
    super.key,
    required this.deliveryMethod,
    required this.cartItems,
    required this.getItemDeliveryFee,
    required this.deliveryFee,
    required this.promoDiscount,
    required this.promoCode,
    required this.paymentMethodLabel,
    required this.grandTotal,
    required this.isProcessing,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Please confirm your order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery: $deliveryMethod'),
            const SizedBox(height: 12),
            ...cartItems.map((item) {
              final fee = getItemDeliveryFee(item);
              final name = item['name']?.toString() ?? 'Product';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
                    Text(
                      fee == 0 ? 'FREE' : 'Rs.${fee.toStringAsFixed(0)}',
                      style: TextStyle(color: fee == 0 ? Colors.green : Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Fee'),
                Text(
                  deliveryFee == 0 ? 'FREE' : 'Rs.${deliveryFee.toStringAsFixed(0)}',
                  style: TextStyle(color: deliveryFee == 0 ? Colors.green : Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (promoDiscount > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Promo (${promoCode ?? ''})'),
                  Text('-PKR ${promoDiscount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text('Payment: $paymentMethodLabel'),
            const SizedBox(height: 10),
            Text('Total Amount: PKR ${grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text('Do you want to place this order?', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: isProcessing ? null : onConfirm,
          child: isProcessing
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Proceed', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}