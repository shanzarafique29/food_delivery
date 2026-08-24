import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/checkout/controller/checkout_controller.dart';
import 'package:food_delivery/features/checkout/views/checkout_payment%20screen.dart';
import 'package:food_delivery/features/checkout/widget/checkout_widget.dart';
import 'package:food_delivery/features/checkout/widget/order_summary_breakdown.dart';
import 'package:food_delivery/features/offers/widgets/promo_code_section.dart';
import 'package:get/get.dart';

class CheckoutDeliveryScreen extends StatefulWidget {
  const CheckoutDeliveryScreen({super.key});

  @override
  State<CheckoutDeliveryScreen> createState() => _CheckoutDeliveryScreenState();
}

class _CheckoutDeliveryScreenState extends State<CheckoutDeliveryScreen> {
  final CheckoutController _controller = CheckoutController();
  late final CartController cartController;

  String name = 'Loading...';
  String address = 'Loading...';
  String phone = 'Loading...';
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController(), permanent: true);
    _fetchUserProfile();
  }

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
            address = data['address']?.toString() ?? 'Address not added';
            phone = data['phone']?.toString() ?? 'Phone not added';
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
      } else if (mounted) {
        setState(() {
          name = 'User';
          address = 'Address not added';
          phone = 'Phone not added';
          isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingProfile = false);
    }
  }

  void _showEditAddressDialog() {
    final nameController = TextEditingController(text: name);
    final addressController = TextEditingController(text: address);
    final phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title:  Text(
            'Edit Address Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                 SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                 SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child:  Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFFFF4B3A),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                final newAddress = addressController.text.trim();
                final newPhone = phoneController.text.trim();

                if (newName.isEmpty || newAddress.isEmpty || newPhone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                          'name': newName,
                          'address': newAddress,
                          'phone': newPhone,
                        }, SetOptions(merge: true));
                  }
                  if (!mounted) return;
                  setState(() {
                    name = newName;
                    address = newAddress;
                    phone = newPhone;
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Address details updated')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('Unable to save address details'),
                    ),
                  );
                }
              },
              child:  Text('Save', style: GoogleSansRoundedStyles.light(
                size: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          ],
        );
      },
    );
  }

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
              icon:  Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title:  Text(
              'Checkout',
              style: GoogleSansRoundedStyles.bold(
                size: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
          ),
          body: isLoadingProfile
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                )
              : Obx(() {
                  final cartItems = cartController.selectedCartItemsList;
                  final subtotal = cartController.selectedSubtotal;
                  final deliveryCharge = _controller.getCalculatedDeliveryFee(
                    cartItems,
                  );
                  final promoDiscount = _controller.getPromoDiscountAmount(
                    subtotal,
                  );
                  final finalTotal = subtotal + deliveryCharge - promoDiscount;

                  if (cartItems.isEmpty) {
                    return Center(
                      child: Text(
                        'Your cart is empty',
                        style: GoogleSansRoundedStyles.bold(
                          size: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding:  EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery',
                          style: GoogleSansRoundedStyles.bold(
                            size: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Address details',
                          style: GoogleSansRoundedStyles.bold(
                            size: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        SizedBox(height: size.height * 0.02),
                        CheckoutWidgets.buildAddressBox(
                          name: name,
                          address: address,
                          phone: phone,
                          onChangePressed: _showEditAddressDialog,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          'Delivery method.',
                          style: GoogleSansRoundedStyles.bold(
                            size: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        SizedBox(height: size.height * 0.02),
                        CheckoutWidgets.buildDeliveryMethodBox(
                          selectedMethod: _controller.selectedDeliveryMethod,
                          onChanged: (value) {
                            if (value == null) return;
                            _controller.setDeliveryMethod(value);
                          },
                        ),
                         SizedBox(height: size.height * 0.03),

                        PromoCodeSection(
                          subtotal: subtotal,
                          appliedOffer: _controller.appliedPromoOffer,
                          onOfferChanged: _controller.setPromoOffer,
                        ),
                         SizedBox(height: size.height * 0.03),

                        OrderSummaryBreakdown(
                          cartItems: cartItems,
                          getItemDeliveryFee: _controller.getItemDeliveryFee,
                          subtotal: subtotal,
                          deliveryFee: deliveryCharge,
                          promoDiscount: promoDiscount,
                          grandTotal: finalTotal,
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutPaymentScreen(
                                    cartItems: cartItems,
                                    totalPrice: subtotal,
                                    deliveryMethod:
                                        _controller.selectedDeliveryMethod,
                                    deliveryAddress: '$name, $address, $phone',
                                    userName: name,
                                    userPhone: phone,
                                    appliedPromoOffer:
                                        _controller.appliedPromoOffer,
                                  ),
                                ),
                              );
                            },
                            child:  Text(
                              'Proceed to payments',
                              style: GoogleSansRoundedStyles.bold(
                                size: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
        );
      },
    );
  }
}

