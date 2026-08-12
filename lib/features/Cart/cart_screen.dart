import 'package:flutter/material.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/checkout/checkout_deliveryscreen.dart';
import 'package:get/get.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/models/productmodel.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  // Same CartController instance ko use karo
  final CartController controller = Get.put(
    CartController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // =========================================
            // TOP BAR
            // =========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // =========================================
            // SWIPE TEXT
            // =========================================
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe_left,
                    size: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'swipe on an item to delete',
                    style: TextStyle(
                      fontSize: 7,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // =========================================
            // CART PRODUCTS
            // =========================================
            Expanded(
              child: Obx(() {
                if (controller.cartItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = controller.cartItems[index];

                    return _cartItem(
                      product,
                      controller,
                    );
                  },
                );
              }),
            ),

            // =========================================
            // COMPLETE ORDER BUTTON
            // =========================================
            Padding(
              padding: const EdgeInsets.fromLTRB(
                40,
                10,
                40,
                20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4B3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () {
                    // ---------------------------------
                    // EMPTY CART CHECK
                    // ---------------------------------
                    if (controller.cartItems.isEmpty) {
                      Get.snackbar(
                        'Cart is empty',
                        'Please add a product first',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    // ---------------------------------
                    // CART ITEMS FIRESTORE DATA
                    // ---------------------------------
                    final cartItems =
                        controller.cartItems.map((product) {
                      return {
                        'id': product.id,
                        'name': product.name,
                        'price': product.price,
                        'imageUrl': product.imageUrl,
                        'category': product.category,
                        'description': product.description,
                        'quantity':
                            controller.getQuantity(product),
                      };
                    }).toList();

                    // ---------------------------------
                    // GO TO DELIVERY CHECKOUT
                    // ---------------------------------
                    Get.to(
                      () => CheckoutDeliveryScreen(
                        cartItems: cartItems,
                        totalPrice: controller.totalPrice,
                      ),
                    );
                  },

                  child: const Text(
                    'complete order',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

// =========================================================
// CART ITEM
// =========================================================

Widget _cartItem(
  ProductModel product,
  CartController controller,
) {
  return Dismissible(
    key: ValueKey(
      product.id ?? product.name,
    ),

    direction: DismissDirection.endToStart,

    background: Container(
      margin: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
      ),
    ),

    onDismissed: (_) {
      controller.removeFromCart(product);
    },

    child: Container(
      height: 52,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          // =====================================
          // PRODUCT IMAGE
          // =====================================
          ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.fastfood,
                            size: 20,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.fastfood,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 10),

          // =====================================
          // NAME + PRICE
          // =====================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Obx(
                  () => Text(
                    '₦${(product.price * controller.getQuantity(product)).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =====================================
          // MINUS
          // =====================================
          GestureDetector(
            onTap: () {
              controller.decreaseQuantity(product);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.remove,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),

          // =====================================
          // QUANTITY
          // =====================================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
            ),
            child: Obx(
              () => Text(
                '${controller.getQuantity(product)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // =====================================
          // PLUS
          // =====================================
          GestureDetector(
            onTap: () {
              controller.increaseQuantity(product);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}