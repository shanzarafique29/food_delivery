import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/checkout/controller/checkout_controller.dart';
import 'package:food_delivery/features/checkout/controller/payment_controller.dart';
import 'package:food_delivery/features/checkout/controller/stripe_payment_controller.dart';
import 'package:food_delivery/features/checkout/widget/bank_transfer_section.dart';
import 'package:food_delivery/features/checkout/widget/order_confirmation_dialog.dart';
import 'package:food_delivery/features/checkout/widget/order_summary_breakdown.dart';
import 'package:food_delivery/features/checkout/widget/payment_method_selector.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:get/get.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final String deliveryMethod;
  final String deliveryAddress;
  final String userName;
  final String userPhone;
  final OfferModel? appliedPromoOffer;

  const CheckoutPaymentScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.deliveryMethod,
    required this.deliveryAddress,
    required this.userName,
    required this.userPhone,
    this.appliedPromoOffer,
  });

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  final CheckoutController _controller = CheckoutController();
  final StripePaymentController _stripeController =
      Get.isRegistered<StripePaymentController>()
      ? Get.find<StripePaymentController>()
      : Get.put(StripePaymentController());
  final PaymentController _paymentController =
      Get.isRegistered<PaymentController>()
      ? Get.find<PaymentController>()
      : Get.put(PaymentController());

  bool isLoading = true;
  bool isDialogOpen = false;

  int _mapPaymentMethodToInt(String method) {
    switch (method.toLowerCase()) {
      case 'bank account':
      case '1':
        return 1;
      case 'cash on delivery':
      case '2':
        return 2;
      case 'card':
      case '0':
      default:
        return 0;
    }
  }

  String _mapIntToPaymentMethod(int index) {
    switch (index) {
      case 1:
        return 'Bank account';
      case 2:
        return 'Cash on delivery';
      case 0:
      default:
        return 'Card';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.selectedDeliveryMethod = widget.deliveryMethod;
    _controller.setPromoOffer(widget.appliedPromoOffer);
    _fetchUserPaymentMethod();
  }

  Future<void> _fetchUserPaymentMethod() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && mounted) {
          final data = doc.data()!;
          final methodStr = data['paymentMethod']?.toString() ?? 'Card';
          setState(() {
            _controller.setPaymentMethodIndex(
              _mapPaymentMethodToInt(methodStr),
            );
            isLoading = false;
          });
        } else if (mounted) {
          setState(() => isLoading = false);
        }
      } else if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  double get deliveryFee =>
      _controller.getCalculatedDeliveryFee(widget.cartItems);
  double get promoDiscount =>
      _controller.getPromoDiscountAmount(widget.totalPrice);
  double get grandTotal => widget.totalPrice + deliveryFee - promoDiscount;

  Future<void> _handleConfirm(
    BuildContext dialogContext,
    String selectedMethodString,
  ) async {
    if (_controller.selectedPaymentMethodIndex == 0) {
      final orderId = await _controller.createPendingCardOrder(
        context: context,
        cartItems: widget.cartItems,
        deliveryAddress: widget.deliveryAddress,
        userName: widget.userName,
        userPhone: widget.userPhone,
      );

      if (orderId == null) {
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        return;
      }

      final success = await _stripeController.payWithCard(
        amount: grandTotal,
        orderId: orderId,
      );

      if (!success) {
        await _controller.cancelPendingOrder(orderId);
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        Get.snackbar(
          'Payment Failed',
          _stripeController.errorMessage.value ?? 'Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (dialogContext.mounted) Navigator.pop(dialogContext);

      await _controller.finalizeCardOrder(
        context: context,
        orderId: orderId,
        cartItems: widget.cartItems,
        userName: widget.userName,
        grandTotal: grandTotal,
      );
      return;
    }

    if (_controller.selectedPaymentMethodIndex == 1) {
      if (!_paymentController.validateForBankTransfer()) {
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        return;
      }
    }

    if (dialogContext.mounted) Navigator.pop(dialogContext);

    await _controller.placeOrderWithDetails(
      context: context,
      cartItems: widget.cartItems,
      baseTotalPrice: widget.totalPrice,
      deliveryAddress: widget.deliveryAddress,
      userName: widget.userName,
      userPhone: widget.userPhone,
      paymentController: _paymentController,
    );
  }

  void _showOrderConfirmation() {
    if (isDialogOpen) return;
    isDialogOpen = true;

    final selectedMethodString = _mapIntToPaymentMethod(
      _controller.selectedPaymentMethodIndex,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Obx(
          () => OrderConfirmationDialog(
            deliveryMethod: _controller.selectedDeliveryMethod,
            cartItems: widget.cartItems,
            getItemDeliveryFee: _controller.getItemDeliveryFee,
            deliveryFee: deliveryFee,
            promoDiscount: promoDiscount,
            promoCode: _controller.appliedPromoOffer?.code,
            paymentMethodLabel: selectedMethodString,
            grandTotal: grandTotal,
            isProcessing:
                _controller.isSaving || _stripeController.isProcessing.value,
            onConfirm: () =>
                _handleConfirm(dialogContext, selectedMethodString),
          ),
        );
      },
    ).then((_) => isDialogOpen = false);
  }

  // void showOrderConfirmation() {
  //   final selectedMethodString = _mapIntToPaymentMethod(
  //     _controller.selectedPaymentMethodIndex,
  //   );
  //   if (isDialogOpen) return;
  //   isDialogOpen = true;
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return Obx(
  //         () => OrderConfirmationDialog(
  //           deliveryMethod: _controller.selectedDeliveryMethod,
  //           cartItems: widget.cartItems,
  //           getItemDeliveryFee: _controller.getItemDeliveryFee,
  //           deliveryFee: deliveryFee,
  //           promoDiscount: promoDiscount,
  //           promoCode: _controller.appliedPromoOffer?.code,
  //           paymentMethodLabel: selectedMethodString,
  //           grandTotal: grandTotal,
  //           isProcessing:
  //               _controller.isSaving || _stripeController.isProcessing.value,
  //           onConfirm: () =>
  //               _handleConfirm(dialogContext, selectedMethodString),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Checkout',
              style: GoogleSansRoundedStyles.bold(
                color: Colors.black,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment',
                        style: GoogleSansRoundedStyles.bold(
                          size: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Payment method',
                        style: GoogleSansRoundedStyles.light(
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PaymentMethodSelector(
                        selectedMethod: _controller.selectedPaymentMethodIndex,
                        onMethodChanged: (int index) {
                          setState(
                            () => _controller.setPaymentMethodIndex(index),
                          );
                        },
                      ),

                      if (_controller.selectedPaymentMethodIndex == 1) ...[
                        const SizedBox(height: 16),
                        BankTransferSection(controller: _paymentController),
                      ],

                      SizedBox(height: size.height * 0.03),
                      OrderSummaryBreakdown(
                        cartItems: widget.cartItems,
                        getItemDeliveryFee: _controller.getItemDeliveryFee,
                        subtotal: widget.totalPrice,
                        deliveryFee: deliveryFee,
                        promoDiscount: promoDiscount,
                        grandTotal: grandTotal,
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _controller.isSaving
                              ? null
                              : _showOrderConfirmation,
                          child: _controller.isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Proceed to payment',
                                  style: GoogleSansRoundedStyles.bold(
                                    size: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
