import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/checkout/controller/payment_controller.dart';
import 'package:food_delivery/features/checkout/widget/order_success_dialog.dart';
import 'package:food_delivery/features/home/view/root_screen.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutController extends ChangeNotifier {
  int selectedPaymentMethodIndex = 0;
  String selectedDeliveryMethod = 'Door delivery';
  String selectedPaymentMethod = 'Card';
  bool isSaving = false;

  OfferModel? appliedPromoOffer;

  void setDeliveryMethod(String method) {
    selectedDeliveryMethod = method;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void setPaymentMethodIndex(int index) {
    selectedPaymentMethodIndex = index;
    selectedPaymentMethod = switch (index) {
      1 => 'Bank account',
      2 => 'Cash on delivery',
      _ => 'Card',
    };
    notifyListeners();
  }

  void setPromoOffer(OfferModel? offer) {
    appliedPromoOffer = offer;
    notifyListeners();
  }

  double getItemDeliveryFee(Map<String, dynamic> item) {
    final bool isFreeDelivery = item['isFreeDelivery'] == true || item['freeDelivery'] == true || item['isFree'] == true;
    if (isFreeDelivery) return 0.0;
    return _toDouble(item['deliveryFee'] ?? item['itemDeliveryFee'] ?? 0);
  }

  double getTotalDeliveryFee(List<Map<String, dynamic>> cartItems) {
    if (selectedDeliveryMethod != 'Door delivery') return 0.0;
    double total = 0.0;
    for (final item in cartItems) {
      total += getItemDeliveryFee(item);
    }
    return total;
  }

  double getCalculatedDeliveryFee(List<Map<String, dynamic>> cartItems) => getTotalDeliveryFee(cartItems);

  double getItemSubtotal(Map<String, dynamic> item) {
    final double price = _toDouble(item['price']);
    final int quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    return price * quantity;
  }

  double getSubtotal(List<Map<String, dynamic>> cartItems) {
    double subtotal = 0.0;
    for (final item in cartItems) {
      subtotal += getItemSubtotal(item);
    }
    return subtotal;
  }

  double getPromoDiscountAmount(double subtotal) {
    if (appliedPromoOffer == null) return 0.0;
    return subtotal * (appliedPromoOffer!.discountPercent / 100);
  }

  double getGrandTotal(List<Map<String, dynamic>> cartItems) {
    final subtotal = getSubtotal(cartItems);
    final deliveryFee = getTotalDeliveryFee(cartItems);
    final promoDiscount = getPromoDiscountAmount(subtotal);
    return subtotal + deliveryFee - promoDiscount;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDeliverySettingsStream() {
    return FirebaseFirestore.instance.collection('settings').doc('delivery').snapshots();
  }

  List<Map<String, dynamic>> getOrderItems(List<Map<String, dynamic>> cartItems) {
    return cartItems.map((item) {
      final double price = _toDouble(item['price']);
      final int quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      final double itemSubtotal = price * quantity;
      final double itemDeliveryFee = getItemDeliveryFee(item);
      final double itemGrandTotal = itemSubtotal + itemDeliveryFee;

      return {
        ...item,
        'price': price,
        'quantity': quantity,
        'productName': item['name']?.toString() ?? '',
        'isFreeDelivery': item['isFreeDelivery'] == true,
        'deliveryFee': itemDeliveryFee,
        'itemDeliveryFee': itemDeliveryFee,
        'itemSubtotal': itemSubtotal,
        'totalPrice': itemSubtotal,
        'itemGrandTotal': itemGrandTotal,
      };
    }).toList();
  }

  String _resolveCartDocId(Map<String, dynamic> item) {
    final productId = item['productId']?.toString();
    if (productId != null && productId.isNotEmpty) return productId;
    final id = item['id']?.toString();
    if (id != null && id.isNotEmpty) return id;
    return item['name']?.toString() ?? '';
  }

  Future<void> _notifyAdminOfNewOrder({required String userName, required double totalAmount, required String orderId}) async {
    try {
      await http.post(
        Uri.parse('https://food-delivery-phi-ebon.vercel.app/api/notify-new-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userName': userName, 'totalAmount': totalAmount, 'orderId': orderId}),
      );
    } catch (_) {
  
    }
  }

  Future<String?> createPendingCardOrder({
    required BuildContext context,
    required List<Map<String, dynamic>> cartItems,
    required String deliveryAddress,
    required String userName,
    required String userPhone,
  }) async {
    if (cartItems.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No items selected for order')));
      }
      return null;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login before placing an order')));
      }
      return null;
    }

    final double subtotal = getSubtotal(cartItems);
    final double totalDeliveryFee = getCalculatedDeliveryFee(cartItems);
    final double promoDiscount = getPromoDiscountAmount(subtotal);
    final double grandTotal = subtotal + totalDeliveryFee - promoDiscount;
    final List<Map<String, dynamic>> orderItems = getOrderItems(cartItems);

    final orderRef = await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': deliveryAddress,
      'items': orderItems,
      'subTotal': subtotal,
      'deliveryFee': totalDeliveryFee,
      'totalDeliveryFee': totalDeliveryFee,
      'promoCode': appliedPromoOffer?.code,
      'promoDiscountAmount': promoDiscount,
      'totalAmount': grandTotal,
      'totalPrice': grandTotal,
      'grandTotal': grandTotal,
      'deliveryOption': selectedDeliveryMethod,
      'deliveryType': selectedDeliveryMethod,
      'deliveryAddress': selectedDeliveryMethod == 'Door delivery' ? deliveryAddress : 'Pickup Store',
      'paymentMethod': selectedPaymentMethod,
      'paymentProofUrl': null,
      'paymentReferenceNumber': null,
      'paymentVerificationStatus': 'pending',
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return orderRef.id;
  }

  
  Future<void> cancelPendingOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    } catch (_) {
  
    }
  }

  Future<void> _finalizeOrder({
    required BuildContext context,
    required String orderId,
    required List<Map<String, dynamic>> cartItems,
    required String userName,
    required double grandTotal,
    PaymentController? paymentController,
  }) async {
    await _notifyAdminOfNewOrder(userName: userName, totalAmount: grandTotal, orderId: orderId);

    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final CollectionReference<Map<String, dynamic>> userCartRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');

      for (final item in cartItems) {
        final String docId = _resolveCartDocId(item);
        if (docId.isNotEmpty) {
          batch.delete(userCartRef.doc(docId));
        }
      }
      await batch.commit();
    }

    if (Get.isRegistered<CartController>()) {
      final CartController cartController = Get.find<CartController>();
      for (final item in cartItems) {
        final String key = _resolveCartDocId(item);
        if (key.isNotEmpty) {
          cartController.quantities.remove(key);
          cartController.selectedItemKeys.remove(key);
          cartController.cartItems.removeWhere((product) => product.id == key || product.name == key);
        }
      }
    }

    appliedPromoOffer = null;
    paymentController?.resetProof();

    if (context.mounted) {
      await showDialog(context: context, barrierDismissible: false, builder: (_) => const OrderSuccessDialog());

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
    }
  }


  Future<void> finalizeCardOrder({
    required BuildContext context,
    required String orderId,
    required List<Map<String, dynamic>> cartItems,
    required String userName,
    required double grandTotal,
  }) async {
    isSaving = true;
    notifyListeners();
    try {
      await _finalizeOrder(context: context, orderId: orderId, cartItems: cartItems, userName: userName, grandTotal: grandTotal);
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }


  Future<void> placeOrderWithDetails({
    required BuildContext context,
    required List<Map<String, dynamic>> cartItems,
    required double baseTotalPrice,
    required String deliveryAddress,
    required String userName,
    required String userPhone,
    PaymentController? paymentController,
  }) async {
    if (isSaving) return;

    if (cartItems.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No items selected for order')));
      }
      return;
    }

    isSaving = true;
    notifyListeners();

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login before placing an order')));
        }
        return;
      }

      final double subtotal = getSubtotal(cartItems);
      final double totalDeliveryFee = getCalculatedDeliveryFee(cartItems);
      final double promoDiscount = getPromoDiscountAmount(subtotal);
      final double grandTotal = subtotal + totalDeliveryFee - promoDiscount;
      final List<Map<String, dynamic>> orderItems = getOrderItems(cartItems);

      final bool isBankTransfer = selectedPaymentMethod == 'Bank account';
      final String paymentVerificationStatus = isBankTransfer ? 'pending' : 'not_applicable';

      final orderRef = await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'userName': userName,
        'userPhone': userPhone,
        'userAddress': deliveryAddress,
        'items': orderItems,
        'subTotal': subtotal,
        'deliveryFee': totalDeliveryFee,
        'totalDeliveryFee': totalDeliveryFee,
        'promoCode': appliedPromoOffer?.code,
        'promoDiscountAmount': promoDiscount,
        'totalAmount': grandTotal,
        'totalPrice': grandTotal,
        'grandTotal': grandTotal,
        'deliveryOption': selectedDeliveryMethod,
        'deliveryType': selectedDeliveryMethod,
        'deliveryAddress': selectedDeliveryMethod == 'Door delivery' ? deliveryAddress : 'Pickup Store',
        'paymentMethod': selectedPaymentMethod,
        'paymentProofUrl': isBankTransfer ? paymentController?.proofImageUrl.value : null,
        'paymentReferenceNumber': isBankTransfer ? paymentController?.referenceNumberController.text.trim() : null,
        'paymentVerificationStatus': paymentVerificationStatus,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _finalizeOrder(
        context: context,
        orderId: orderRef.id,
        cartItems: cartItems,
        userName: userName,
        grandTotal: grandTotal,
        paymentController: paymentController,
      );
    } catch (e) {
      debugPrint('Place order error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0.0;
  }
}