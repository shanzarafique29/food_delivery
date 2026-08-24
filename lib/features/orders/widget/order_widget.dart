import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';

class OrderWidgets {
  static Color statusColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'pending':
        return Colors.orange;

      case 'preparing':
        return Colors.blue;

      case 'on the way':
      case 'ontheway':
        return Colors.deepPurple;

      case 'delivered':
        return Colors.green;

      case 'cancelled':
      case 'canceled':
        return AppColor.text4;

      default:
        return AppColor.primary;
    }
  }

  static Widget buildEmptyOrders(
    BuildContext context, {
    IconData icon = Icons.shopping_cart_outlined,
    String title = 'No orders yet',
    String subtitle = 'Hit the orange button down below to Create an order',
    VoidCallback? onStartOrdering,
  }) {
  
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(icon, size: 54, color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleSansRoundedStyles.bold(size: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleSansRoundedStyles.bold(size: 14, height: 1.5, color: Colors.grey.shade600)
            ),
            if (onStartOrdering != null) ...[
              SizedBox(height: 30),
              SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton(
                  onPressed: onStartOrdering,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child:  Text('Start ordering', style: GoogleSansRoundedStyles.bold(size: 16, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget buildOrderCard({
    String orderId = '',
    String status = 'Pending',
    String deliveryType = 'Door delivery',
    double totalPrice = 0,
    List<Map<String, dynamic>> items = const [],
    String? cancelRequestStatus,
    VoidCallback? onCancelPressed,
    String? paymentVerificationStatus,
  }) {
    final color = statusColor(status);
    final normalizedStatus = status.trim().toLowerCase();

    final isClosed = normalizedStatus == 'delivered' || normalizedStatus == 'cancelled' || normalizedStatus == 'canceled';
    final canRequestCancel = onCancelPressed != null && !isClosed && cancelRequestStatus != 'pending';

    final Map<String, dynamic>? firstItem = items.isNotEmpty ? items.first : null;
    final rawProductName = firstItem?['productName']?.toString() ?? firstItem?['name']?.toString() ?? '';
    final firstItemName = rawProductName.trim().isNotEmpty ? rawProductName : 'Food item';
    final firstItemImage = firstItem?['imageUrl']?.toString() ?? '';
    final extraItemsCount = items.length > 1 ? items.length - 1 : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order #$orderId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: firstItemImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: firstItemImage,
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                        placeholder: (_, __) {
                          return Container(
                            width: 62,
                            height: 62,
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                          );
                        },
                        errorWidget: (_, __, ___) {
                          return _foodPlaceholder();
                        },
                      )
                    : _foodPlaceholder(),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstItemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    if (extraItemsCount > 0) ...[
                      const SizedBox(height: 3),
                      Text(
                        '+$extraItemsCount more item${extraItemsCount > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.delivery_dining_outlined, size: 15, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            deliveryType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              Text(
                'PKR ${totalPrice.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 17, color: color, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (paymentVerificationStatus == 'pending') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 17, color: Colors.blue.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment proof submitted. Waiting for admin verification.',
                      style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (paymentVerificationStatus == 'verified') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_rounded, size: 17, color: Colors.green.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment verified by admin.',
                      style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.green.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (paymentVerificationStatus == 'rejected') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, size: 17, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment could not be verified. Order was cancelled.',
                      style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.red.shade800, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (cancelRequestStatus == 'pending') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.hourglass_top_rounded, size: 17, color: Colors.orange.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cancellation request sent. Waiting for admin approval.',
                      style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.orange.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (cancelRequestStatus == 'rejected') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 17, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your cancellation request was declined by admin.',
                      style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.red.shade800, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (canRequestCancel) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: OutlinedButton(
                onPressed: onCancelPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel Order', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _foodPlaceholder() {
    return Container(
      width: 62,
      height: 62,
      color: Colors.grey.shade100,
      child: Icon(Icons.fastfood_rounded, size: 25, color: Colors.grey.shade400),
    );
  }
}