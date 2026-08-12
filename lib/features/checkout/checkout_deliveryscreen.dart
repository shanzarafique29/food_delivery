import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:food_delivery/features/checkout/checkout_payment%20screen.dart';
import 'package:food_delivery/features/checkout/widget/checkout_widget.dart';

import 'controller/checkout_controller.dart';

class CheckoutDeliveryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutDeliveryScreen({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<CheckoutDeliveryScreen> createState() =>
      _CheckoutDeliveryScreenState();
}

class _CheckoutDeliveryScreenState
    extends State<CheckoutDeliveryScreen> {
  final CheckoutController _controller = CheckoutController();

  String name = 'Loading...';
  String address = 'Loading...';
  String phone = 'Loading...';

  bool isLoadingProfile = true;

  // ============================================================
  // DELIVERY CHARGES
  // ============================================================

  double get deliveryCharge {
    if (_controller.selectedDeliveryMethod == 'Door delivery') {
      return 1000;
    }

    if (_controller.selectedDeliveryMethod == 'Pick up') {
      return 0;
    }

    return 0;
  }

  double get finalTotal {
    return widget.totalPrice + deliveryCharge;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // ============================================================
  // FETCH PROFILE
  // ============================================================

  Future<void> _fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && mounted) {
          final data = doc.data()!;

          setState(() {
            name = data['name']?.toString() ?? 'User';
            address = data['address']?.toString() ??
                'Address not added';
            phone = data['phone']?.toString() ??
                'Phone not added';

            isLoadingProfile = false;
          });
        } else if (mounted) {
          setState(() {
            name = 'User';
            address = 'Address not added';
            phone = 'Phone not added';
            isLoadingProfile = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingProfile = false;
        });
      }
    }
  }

  // ============================================================
  // EDIT ADDRESS
  // ============================================================

  void _showEditAddressDialog() {
    final nameController =
        TextEditingController(text: name);

    final addressController =
        TextEditingController(text: address);

    final phoneController =
        TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Edit Address Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF4B3A),
              ),

              onPressed: () async {
                final newName =
                    nameController.text.trim();

                final newAddress =
                    addressController.text.trim();

                final newPhone =
                    phoneController.text.trim();

                if (newName.isEmpty ||
                    newAddress.isEmpty ||
                    newPhone.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all fields',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  final user =
                      FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set(
                      {
                        'name': newName,
                        'address': newAddress,
                        'phone': newPhone,
                      },
                      SetOptions(merge: true),
                    );
                  }

                  if (!mounted) return;

                  setState(() {
                    name = newName;
                    address = newAddress;
                    phone = newPhone;
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Address details updated',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Unable to save address details',
                      ),
                    ),
                  );
                }
              },

              child: const Text(
                'Save',
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
      backgroundColor: const Color(0xFFF5F5F8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
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

      body: isLoadingProfile
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF4B3A),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Delivery',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Address details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  CheckoutWidgets.buildAddressBox(
                    name: name,
                    address: address,
                    phone: phone,
                    onChangePressed:
                        _showEditAddressDialog,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Delivery method.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  CheckoutWidgets.buildDeliveryMethodBox(
                    selectedMethod:
                        _controller.selectedDeliveryMethod,

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _controller
                            .setDeliveryMethod(value);
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  // DELIVERY CHARGE
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery charge',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        deliveryCharge == 0
                            ? 'Free'
                            : '₦${deliveryCharge.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // TOTAL
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        '₦${finalTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF4B3A),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutPaymentScreen(
                              cartItems:
                                  widget.cartItems,

                              totalPrice:
                                  finalTotal,

                              deliveryMethod:
                                  _controller
                                      .selectedDeliveryMethod,

                              deliveryAddress:
                                  '$name, $address, $phone',
                            ),
                          ),
                        );
                      },

                      child: const Text(
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