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
  State<CheckoutDeliveryScreen> createState() => _CheckoutDeliveryScreenState();
}

class _CheckoutDeliveryScreenState extends State<CheckoutDeliveryScreen> {
  final CheckoutController _controller = CheckoutController();
  
  String name = 'Loading...';
  String address = 'Loading...';
  String phone = 'Loading...';
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          setState(() {
            name = doc.data()?['name'] ?? 'Marvis Kparobo';
            address = doc.data()?['address'] ?? 'No 15 uti street off ovie palace road effurun delta state';
            phone = doc.data()?['phone'] ?? '+234 9011039271';
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

  void _showEditAddressDialog() {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController addressController = TextEditingController(text: address);
    final TextEditingController phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B3A)),
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  address = addressController.text;
                  phone = phoneController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
      body: isLoadingProfile
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF4B3A)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address details',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  CheckoutWidgets.buildAddressBox(
                    name: name,
                    address: address,
                    phone: phone,
                    onChangePressed: _showEditAddressDialog,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Delivery method.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  CheckoutWidgets.buildDeliveryMethodBox(
                    selectedMethod: _controller.selectedDeliveryMethod,
                    onChanged: (value) {
                      setState(() {
                        _controller.setDeliveryMethod(value!);
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPaymentScreen(
                              cartItems: widget.cartItems,
                              totalPrice: widget.totalPrice,
                              deliveryMethod: _controller.selectedDeliveryMethod,
                              deliveryAddress: '$name, $address, $phone',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Proceed to payment',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}