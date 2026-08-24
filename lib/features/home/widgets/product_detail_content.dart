import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/cart/controller/cart_controller.dart';
import 'package:food_delivery/features/home/widgets/product_info_section.dart';
import 'package:food_delivery/features/home/widgets/product_price_section.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:food_delivery/utils/offer_helper.dart';
import 'package:food_delivery/widgets/bounce_tap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductModel product;
  final CartController cartController;
  final MyOffersController offersController;

  const ProductDetailContent({
    super.key,
    required this.product,
    required this.cartController,
    required this.offersController,
  });

  String _deliveryInfoText() {
    if (product.deliveryInfo != null &&
        product.deliveryInfo!.trim().isNotEmpty) {
      return product.deliveryInfo!;
    }
    return (product.isFreeDelivery ?? false)
        ? 'Delivered between Monday Aug and Thursday Sep with Free Delivery.'
        : 'Delivered between Monday Aug and Thursday Sep for standard shipping rate.';
  }

  String _returnPolicyText() {
    if (product.termsPolicy != null && product.termsPolicy!.trim().isNotEmpty) {
      return product.termsPolicy!;
    }
    return 'All our foods are double checked before leaving our store so if you found any loss you can contact us.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'product-image-${product.id ?? product.name}',
                      child: ClipOval(
                        child: product.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                width: 220,
                                height: 220,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 220,
                                        height: 220,
                                        color: Colors.white,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade200,
                                  child: Image.asset(
                                    'assets/images/app logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: Image.asset(
                                  'assets/images/app logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: GoogleSansRoundedStyles.bold(
                    size: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Obx(() {
                  final activeOffer = OfferHelper.findActiveOffer(
                    offersController.offersList,
                    product,
                  );
                  final finalPrice = OfferHelper.getFinalPrice(
                    product.price,
                    activeOffer,
                  );

                  return ProductPriceSection(
                    product: product,
                    activeOffer: activeOffer,
                    finalPrice: finalPrice,
                  );
                }),

                SizedBox(height: 30),

                ProductInfoSection(
                  title: 'Delivery info',
                  content: _deliveryInfoText(),
                ),

                SizedBox(height: 24),

                ProductInfoSection(
                  title: 'Return policy',
                  content: _returnPolicyText(),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: BounceTap(
              onTap: () {
                cartController.addToCart(product);
                Get.snackbar(
                  "Success",
                  "${product.name} added to cart",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.0),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add to cart',
                  style: GoogleSansRoundedStyles.bold(
                    size: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
