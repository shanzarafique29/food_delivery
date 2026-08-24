import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/Cart/widgets/cart_item_tile.dart';
import 'package:food_delivery/features/checkout/views/checkout_deliveryscreen.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Text(
                      'Cart',
                      style: GoogleSansRoundedStyles.bold(
                        size: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            Obx(() {
              if (controller.cartItems.isEmpty) {
                return SizedBox();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.swipe_left, size: 14, color: Colors.black),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          'swipe on an item to delete ',
                          style: GoogleSansRoundedStyles.regular(
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: controller.isAllSelected,
                            activeColor: AppColor.primary,
                            onChanged: (_) => controller.toggleSelectAll(),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        GestureDetector(
                          onTap: controller.toggleSelectAll,
                          child: Text(
                            'Select All',
                            style: GoogleSansRoundedStyles.regular(
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: Obx(() {
                if (controller.cartItems.isEmpty) {
                  return Center(
                    child: Text(
                      'Your cart is empty',
                      style: GoogleSansRoundedStyles.regular(
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = controller.cartItems[index];
                    return CartItemTile(
                      product: product,
                      cartController: controller,
                    );
                  },
                );
              }),
            ),

            Obx(() {
              if (controller.cartItems.isEmpty) {
                return SizedBox();
              }

              final bool hasSelection = controller.selectedItemKeys.isNotEmpty;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Subtotal',
                          style: GoogleSansRoundedStyles.regular(
                            size: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'PKR ${controller.selectedSubtotal.toStringAsFixed(0)}',
                          style: GoogleSansRoundedStyles.bold(
                            size: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Delivery Fee',
                          style: GoogleSansRoundedStyles.regular(
                            size: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          controller.selectedDeliveryFee == 0.0
                              ? 'Free'
                              : 'PKR ${controller.selectedDeliveryFee.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: controller.selectedDeliveryFee == 0.0
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Payment',
                          style: GoogleSansRoundedStyles.regular(
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                        Text(
                          'PKR ${controller.finalTotal.toStringAsFixed(0)}',
                          style: GoogleSansRoundedStyles.regular(
                            size: 15,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: !hasSelection
                            ? null
                            : () {
                                Get.to(() => CheckoutDeliveryScreen());
                              },
                        child: Text(
                          hasSelection
                              ? 'Complete Order (${controller.selectedItemKeys.length})'
                              : 'Select Item to Continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: hasSelection
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
