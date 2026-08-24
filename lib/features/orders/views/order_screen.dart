import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/checkout/views/checkout_deliveryscreen.dart';
import 'package:food_delivery/features/orders/widget/cancel_order_dialog.dart';
import 'package:food_delivery/features/orders/widget/order_widget.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';

class OrderScreen extends StatefulWidget {
  final ProductModel? product;
  final OfferModel? offer;
  final List<String> statuses;
  final String screenTitle;
  final IconData emptyIcon;
  final String emptyTitle;
  final bool showClearHistory;

  const OrderScreen({
    super.key,
    this.product,
    this.offer,
    this.statuses = OrderController.activeStatuses,
    this.screenTitle = 'Orders',
    this.emptyIcon = Icons.shopping_cart_outlined,
    this.emptyTitle = 'No orders yet',
    this.showClearHistory = false,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool get _isHistoryView =>
      widget.statuses.length == OrderController.historyStatuses.length &&
      widget.statuses.every((s) => OrderController.historyStatuses.contains(s));

  @override
  Widget build(BuildContext context) {
    final OrderController orderController =
        Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController());
    final user = FirebaseAuth.instance.currentUser;

    double originalPrice = widget.product?.price ?? 0.0;
    double finalPrice = originalPrice;
    if (widget.offer != null) {
      finalPrice = originalPrice * (1 - (widget.offer!.discountPercent / 100));
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product != null ? 'Checkout' : widget.screenTitle,
          style: GoogleSansRoundedStyles.bold(color: Colors.black, size: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: widget.showClearHistory
            ? [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title:  Text('Clear History?'),
                        content:  Text('This will hide all your past orders from this screen. This cannot be undone.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              await orderController.clearHistory();
                              if (dialogContext.mounted) Navigator.pop(dialogContext);
                            },
                            child:  Text('Clear', style: TextStyle(color: AppColor.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Clear', style: TextStyle(color: AppColor.primary)),
                ),
              ]
            : null,
      ),
      body: widget.product != null
          ? _buildSingleItemCheckout(context, originalPrice, finalPrice)
          : _buildOrdersList(context, orderController, user),
    );
  }

  Widget _buildSingleItemCheckout(BuildContext context, double originalPrice, double finalPrice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product!.name, style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (widget.offer != null) ...[
                    Row(
                      children: [
                        Text(
                          "PKR ${originalPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough),
                        ),
                       SizedBox(width: 8),
                        Text(
                          "PKR ${finalPrice.toStringAsFixed(2)}",
                          style:  TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                     SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColor.text4.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "Promo Applied: ${widget.offer!.code} (${widget.offer!.discountPercent}% OFF)",
                        style:  TextStyle(color: AppColor.text4, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "PKR  ${originalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
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
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () async {
                final cartController = Get.isRegistered<CartController>() ? Get.find<CartController>() : Get.put(CartController());
                final productToAdd = widget.product!.copyWith(price: finalPrice);
                await cartController.addToCart(productToAdd);

                if (!context.mounted) return;

                Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutDeliveryScreen()));
              },
              child: Text("Place Order (PKR ${finalPrice.toStringAsFixed(2)})", style:  GoogleSansRoundedStyles.medium(color: Colors.white,size: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, OrderController orderController, User? user) {
    if (user == null) {
      return const Center(child: Text('Please login to view orders'));
    }

    return StreamBuilder(
      stream: orderController.getUserOrders(statuses: widget.statuses),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColor.primary));
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText('Unable to load orders:\n${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            ),
          );
        }
       
         final orderDocs = (snapshot.data?.docs ?? []).where((doc) => doc.data()['hiddenByUser'] != true).toList();
        if (orderDocs.isEmpty) {
          return OrderWidgets.buildEmptyOrders(
            context,
            icon: widget.emptyIcon,
            title: widget.emptyTitle,
            subtitle: 'Hit the orange button down below to Create an order',
            onStartOrdering: () => Navigator.popUntil(context, (route) => route.isFirst),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderDocs.length,
          itemBuilder: (context, index) {
            final doc = orderDocs[index];
            final orderData = doc.data();

            final totalPrice = _toDouble(orderData['totalPrice'] ?? orderData['totalAmount'] ?? orderData['grandTotal']);
            final status = (orderData['status']?.toString().isNotEmpty ?? false) ? orderData['status'].toString() : 'Pending';
            final deliveryType = (orderData['deliveryType']?.toString().isNotEmpty ?? false)
                ? orderData['deliveryType'].toString()
                : (orderData['deliveryOption']?.toString() ?? 'Door delivery');
            final shortId = doc.id.length >= 6 ? doc.id.substring(0, 6) : doc.id;
            final cancelRequestStatus = orderData['cancelRequestStatus']?.toString();
            final items = (orderData['items'] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
             final paymentVerificationStatus = orderData['paymentVerificationStatus']?.toString();
            final card = OrderWidgets.buildOrderCard(
              orderId: shortId,
              status: status,
              deliveryType: deliveryType,
              totalPrice: totalPrice,
              items: items,
              paymentVerificationStatus: paymentVerificationStatus,
              cancelRequestStatus: cancelRequestStatus,
              onCancelPressed: (status == 'Delivered' || status == 'Cancelled')
                  ? null
                  : () => showDialog(context: context, builder: (_) => CancelOrderDialog(orderId: doc.id, controller: orderController)),
            );
            final isClosed = status == 'Delivered' || status == 'Cancelled';
            if (_isHistoryView && isClosed) {
              return Dismissible(
                key: ValueKey(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin:  EdgeInsets.only(bottom: 16),
                  alignment: Alignment.centerRight,
                  padding:  EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(20)),
                  child:  Icon(Icons.delete_outline, color: Colors.white, size: 26),
                ),
                onDismissed: (_) => orderController.hideOrder(doc.id),
                child: card,
              );
            }

            return card;
          },
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