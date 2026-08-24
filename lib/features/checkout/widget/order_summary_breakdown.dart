import 'package:flutter/material.dart';

class OrderSummaryBreakdown extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double Function(Map<String, dynamic>) getItemDeliveryFee;
  final double subtotal;
  final double deliveryFee;
  final double promoDiscount; 
  final double grandTotal;
  final bool showItemBreakdown;

  const OrderSummaryBreakdown({
    super.key,
    required this.cartItems,
    required this.getItemDeliveryFee,
    required this.subtotal,
    required this.deliveryFee,
    this.promoDiscount = 0, 
    required this.grandTotal,
    this.showItemBreakdown = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showItemBreakdown) ...[
          _deliveryChargesCard(),
          const SizedBox(height: 20),
        ],
        _summaryRow('Subtotal', subtotal),
        const SizedBox(height: 8),
        _summaryRow('Delivery Fee', deliveryFee, highlightFree: true),
        if (promoDiscount > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Promo Discount', style: TextStyle(fontSize: 15, color: Colors.grey)),
              Text('-Rs.${promoDiscount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
        const Divider(height: 25),
        _summaryRow('Total', grandTotal, isTotal: true),
      ],
    );
  }

  Widget _deliveryChargesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery charges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...cartItems.map((item) {
            final fee = getItemDeliveryFee(item);
            final name = item['name']?.toString() ?? 'Product';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)),
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
              const Text('Total delivery', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                deliveryFee == 0 ? 'FREE' : 'Rs.${deliveryFee.toStringAsFixed(0)}',
                style: TextStyle(color: deliveryFee == 0 ? Colors.green : Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false, bool highlightFree = false}) {
    final isFree = highlightFree && value == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 17 : 15, color: Colors.grey)),
        Text(
          isFree ? 'FREE' : 'Rs.${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: isFree ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}