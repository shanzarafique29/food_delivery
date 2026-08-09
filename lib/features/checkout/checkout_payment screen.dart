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
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  final CheckoutController _controller = CheckoutController();
  bool isLoading = true;
  
  // Yahan 'late' hata kar direct widget.deliveryMethod assign kar diya hai
  late String currentDeliveryMethod = widget.deliveryMethod;

  @override
  void initState() {
    super.initState();
    _fetchUserProfilePayment();
  }

  Future<void> _fetchUserProfilePayment() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          setState(() {
            _controller.selectedPaymentMethod = doc.data()?['paymentMethod'] ?? 'Card';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF4B3A)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment method',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF725E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.credit_card, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 15),
                              const Text('Card', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          value: 'Card',
                          groupValue: _controller.selectedPaymentMethod,
                          activeColor: const Color(0xFFFF4B3A),
                          onChanged: (value) {
                            setState(() {
                              _controller.setPaymentMethod(value!);
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEB4796),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 15),
                              const Text('Bank account', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          value: 'Bank account',
                          groupValue: _controller.selectedPaymentMethod,
                          activeColor: const Color(0xFFFF4B3A),
                          onChanged: (value) {
                            setState(() {
                              _controller.setPaymentMethod(value!);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Delivery method.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Door delivery', style: TextStyle(fontWeight: FontWeight.w500)),
                          value: 'Door delivery',
                          groupValue: currentDeliveryMethod,
                          activeColor: const Color(0xFFFF4B3A),
                          onChanged: (value) {
                            setState(() {
                              currentDeliveryMethod = value!;
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 20, endIndent: 20),
                        RadioListTile<String>(
                          title: const Text('Pick up', style: TextStyle(fontWeight: FontWeight.w500)),
                          value: 'Pick up',
                          groupValue: currentDeliveryMethod,
                          activeColor: const Color(0xFFFF4B3A),
                          onChanged: (value) {
                            setState(() {
                              currentDeliveryMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      Text(
                        '${widget.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4B3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _controller.isSaving
                          ? null
                          : () {
                              // Yahan popup dialog show ho raha hai
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                      'Please note',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'DELIVERY TO MAINLAND',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'N1000 - N2000',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'DELIVERY TO ISLAND',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'N2000 - N3000',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context), // Popup band hojaye ga
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFFF4B3A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context); // Pehle popup band ho

                                              // Phir actual order place ho ga
                                              await _controller.placeOrderWithDetails(
                                                context: context,
                                                cartItems: widget.cartItems,
                                                totalPrice: widget.totalPrice,
                                                deliveryMethod: currentDeliveryMethod,
                                                deliveryAddress: widget.deliveryAddress,
                                              );
                                            },
                                            child: const Text(
                                              'Proceed',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          child: _controller.isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Proceed to payment',
                                  style: TextStyle(
                                    fontSize: 16,
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
  }
}