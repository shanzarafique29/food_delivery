import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/cart/controller/cart_controller.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/home/view/product_detail_screen.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:food_delivery/utils/offer_helper.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteItemCard extends StatelessWidget {
  final ProductModel product;
  final OfferModel? linkedOffer;
  final FavoriteController favoriteController;

  const FavoriteItemCard({
    super.key,
    required this.product,
    required this.linkedOffer,
    required this.favoriteController,
  });

  @override
  Widget build(BuildContext context) {
    final double originalPrice = product.price;
    final double finalPrice = OfferHelper.getFinalPrice(
      originalPrice,
      linkedOffer,
    );
   final size = MediaQuery.of(context).size;
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding:  EdgeInsets.only(right: 20),
        margin:  EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.text4,
          borderRadius: BorderRadius.circular(16),
        ),
        child:  Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => favoriteController.toggleFavorite(product),
      child: GestureDetector(
        onTap: () => Get.to(() => ProductDetailScreen(product: product)),
        child: Container(
          margin:  EdgeInsets.only(bottom: 16),
          padding:  EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset:  Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: size.width * 0.2,
                                height: size.height * 0.2,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: size.width * 0.2,
                                height: size.height * 0.2,
                              color: Colors.grey.shade200,
                              child: Image.asset('assets/images/app logo.png'),
                            ),
                          )
                        : Container(
                             width: size.width * 0.2,
                                height: size.height * 0.2,
                            color: Colors.grey.shade200,
                            child: Image.asset('assets/images/app logo.png'),
                          ),
                  ),
                  if (linkedOffer != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration:  BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          "${linkedOffer!.discountPercent.toInt()}% OFF",
                          style: GoogleSansRoundedStyles.bold(
                            size: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                    ),
                ],
              ),
               SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleSansRoundedStyles.bold(
                        size: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description.isNotEmpty
                          ? product.description
                          : "Delicious food item",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleSansRoundedStyles.regular(
                        size: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                     SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        if (linkedOffer != null) ...[
                          Text(
                            "Rs.${originalPrice.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                           SizedBox(width: size.width * 0.02),
                        ],
                        Text(
                          "Rs.${finalPrice.toStringAsFixed(0)}",
                          style: GoogleSansRoundedStyles.bold(
                            size: 15,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: AppColor.primary,
                      size: 22,
                    ),
                    onPressed: () => favoriteController.toggleFavorite(product),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration:  BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon:  Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        final cartController = Get.put(CartController());
                        await cartController.addToCart(product);
                        Get.snackbar(
                          "Success",
                          "${product.name} added to cart",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                          duration:  Duration(seconds: 2),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}