import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/home/view/product_detail_screen.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/models/offermodel.dart' hide ProductModel;
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final OfferModel? offer;
  final VoidCallback? onTap;

  ProductCard({
    super.key,
    required this.product,
    this.offer,
    this.onTap,
  });

  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    final offersController = Get.find<MyOffersController>();
      final size = MediaQuery.of(context).size;
    return Obx(() {
      OfferModel? activeOffer =
          offer ??
          offersController.offersList.firstWhereOrNull((o) {
            final now = DateTime.now();
            if (!o.isActive) return false;
            if (o.expiryDate != null && o.expiryDate!.isBefore(now)) {
              return false;
            }

            bool matchesProduct =
                o.productId != null && o.productId == product.id;
            bool matchesDirectOffer =
                product.offerId != null && o.id == product.offerId;

            return matchesProduct || matchesDirectOffer;
          });

      double originalPrice = product.price;
      double finalPrice = originalPrice;

      if (activeOffer != null) {
        finalPrice = originalPrice * (1 - (activeOffer.discountPercent / 100));
      }

      return GestureDetector(
        onTap:
            onTap ??
            () {
              Get.to(() => ProductDetailScreen(product: product));
            },
        child: Container(
          width: 155,
          height: 230,
          margin:  EdgeInsets.only(top: 40),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 40,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset:  Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
      
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleSansRoundedStyles.bold(
                          size: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),

                      if (activeOffer != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Rs.${originalPrice.toStringAsFixed(0)}',
                              style:  TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                           SizedBox(width: 6),
                            Text(
                              'Rs${finalPrice.toStringAsFixed(0)}',
                              style: GoogleSansRoundedStyles.bold(
                                color: AppColor.primary,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 6),
            
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${activeOffer.discountPercent.toInt()}% OFF",
                            style: GoogleSansRoundedStyles.bold(
                              color: Colors.white,
                              size: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Rs${originalPrice.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: GoogleSansRoundedStyles.bold(
                            color: AppColor.primary,
                            size: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Hero(
                     tag: 'product-image-${product.id ?? product.name}',
                    child: ClipOval(
                      child: product.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade100,
                                child: Image.asset('assets/images/app logo.png', fit: BoxFit.cover,),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey.shade100,
                              child:  Image.asset('assets/images/app logo.png', fit: BoxFit.cover,),
                            ),
                    ),
                  ),
                ),
              ),
              if (product.isFreeDelivery ?? false)
                Positioned(
                  top: 8,
                  left: 2,
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:  AppColor.text4,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                          offset:  Offset(0, 2),
                        ),
                      ],
                    ),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'FREE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}