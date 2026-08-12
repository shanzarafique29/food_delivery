import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/checkout_controller.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final String deliveryMethod;
  final String deliveryAddress;

  const CheckoutPaymentScreen({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.deliveryMethod,
    required this.deliveryAddress,
  }) : super(key: key);

  @override
  State<CheckoutPaymentScreen> createState() =>
      _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState
    extends State<CheckoutPaymentScreen> {
  final CheckoutController _controller =
      CheckoutController();

  bool isLoading = true;

  late String currentDeliveryMethod;

  @override
  void initState() {
    super.initState();

    currentDeliveryMethod =
        widget.deliveryMethod;

    _fetchUserPaymentMethod();
  }

  // ============================================================
  // GET PAYMENT METHOD FROM PROFILE
  // ============================================================

  Future<void> _fetchUserPaymentMethod() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (doc.exists && mounted) {
          final data = doc.data()!;

          setState(() {
            _controller.selectedPaymentMethod =
                data['paymentMethod']?.toString() ??
                    'Card';

            isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // PLACE ORDER POPUP
  // ============================================================

  void _showOrderConfirmation() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            'Please confirm your order',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'Delivery: $currentDeliveryMethod',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Payment: ${_controller.selectedPaymentMethod}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Total: ₦${widget.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Do you want to place this order?',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                // Sirf popup close hoga
                // Order place NAHI hoga
                Navigator.pop(dialogContext);
              },

              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF4B3A),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),

              onPressed: _controller.isSaving
                  ? null
                  : () async {
                      // Popup close
                      Navigator.pop(
                        dialogContext,
                      );

                      // Order Firestore mein save
                      await _controller
                          .placeOrderWithDetails(
                        context: context,

                        cartItems:
                            widget.cartItems,

                        totalPrice:
                            widget.totalPrice,

                        deliveryMethod:
                            currentDeliveryMethod,

                        deliveryAddress:
                            widget.deliveryAddress,
                      );
                    },

              child: const Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F8),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xFFFF4B3A),
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Payment method',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // PAYMENT METHODS
                  // ==================================================

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            'Card',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          value: 'Card',

                          groupValue:
                              _controller
                                  .selectedPaymentMethod,

                          activeColor:
                              const Color(
                            0xFFFF4B3A,
                          ),

                          onChanged:
                              (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              _controller
                                  .setPaymentMethod(
                                value,
                              );
                            });
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 20,
                          endIndent: 20,
                        ),

                        RadioListTile<String>(
                          title: const Text(
                            'Bank account',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          value:
                              'Bank account',

                          groupValue:
                              _controller
                                  .selectedPaymentMethod,

                          activeColor:
                              const Color(
                            0xFFFF4B3A,
                          ),

                          onChanged:
                              (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              _controller
                                  .setPaymentMethod(
                                value,
                              );
                            });
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 20,
                          endIndent: 20,
                        ),

                        RadioListTile<String>(
                          title: const Text(
                            'PayPal',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          value: 'PayPal',

                          groupValue:
                              _controller
                                  .selectedPaymentMethod,

                          activeColor:
                              const Color(
                            0xFFFF4B3A,
                          ),

                          onChanged:
                              (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              _controller
                                  .setPaymentMethod(
                                value,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // DELIVERY METHOD
                  // ==================================================

                  const Text(
                    'Delivery method',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            'Door delivery',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          value:
                              'Door delivery',

                          groupValue:
                              currentDeliveryMethod,

                          activeColor:
                              const Color(
                            0xFFFF4B3A,
                          ),

                          onChanged:
                              (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              currentDeliveryMethod =
                                  value;
                            });
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 20,
                          endIndent: 20,
                        ),

                        RadioListTile<String>(
                          title: const Text(
                            'Pick up',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          value: 'Pick up',

                          groupValue:
                              currentDeliveryMethod,

                          activeColor:
                              const Color(
                            0xFFFF4B3A,
                          ),

                          onChanged:
                              (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              currentDeliveryMethod =
                                  value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ==================================================
                  // TOTAL
                  // ==================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        '₦${widget.totalPrice.toStringAsFixed(0)}',

                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // PROCEED BUTTON
                  // ==================================================

                  SizedBox(
                    width:
                        double.infinity,

                    height: 60,

                    child:
                        ElevatedButton(
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xFFFF4B3A,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            30,
                          ),
                        ),
                      ),

                      onPressed:
                          _controller.isSaving
                              ? null
                              : _showOrderConfirmation,

                      child:
                          _controller.isSaving
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )
                              : const Text(
                                  'Proceed to payment',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}