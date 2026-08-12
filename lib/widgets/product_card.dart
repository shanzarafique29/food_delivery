// // import 'package:flutter/material.dart';
// // import 'package:food_delivery/const/app_colors.dart';
// // import 'package:food_delivery/const/app_fonts.dart';
// // import 'package:food_delivery/models/productmodel.dart';

// // class ProductCard extends StatelessWidget {
// //   final ProductModel product;
// //   final VoidCallback? onTap;

// //   const ProductCard({super.key, required this.product, this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 155,
// //         height: 220,
// //         margin: const EdgeInsets.only(top: 40),
// //         child: Stack(
// //           alignment: Alignment.topCenter,
// //           clipBehavior: Clip.none,
// //           children: [
// //             Positioned(
// //               top: 40,
// //               bottom: 0,
// //               left: 0,
// //               right: 0,
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(30),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withValues(alpha: 0.03),
// //                       blurRadius: 20,
// //                       spreadRadius: 1,
// //                       offset:  Offset(0, 10),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.end,
// //                   children: [
// //                     Text(
// //                       product.name,
// //                       textAlign: TextAlign.center,
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: GoogleSansRoundedStyles.bold(
// //                         size: 17,
// //                         color: Colors.black,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                     ),
// //                      SizedBox(height: 12),
// //                     Text(
// //                       'N${product.price.toStringAsFixed(2)}',
// //                       textAlign: TextAlign.center,
// //                       style: GoogleSansRoundedStyles.bold(
// //                         color: AppColor.primary,
// //                         size: 15,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                      SizedBox(height: 10),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             Positioned(
// //               top: 0,
// //               child: Container(
// //                 width: 110,
// //                 height: 110,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withValues(alpha: 0.06),
// //                       blurRadius: 15,
// //                       offset:  Offset(0, 8),
// //                     ),
// //                   ],
// //                 ),
// //                 child: ClipOval(
// //                   child: product.imageUrl.isNotEmpty
// //                       ? Image.network(
// //                           product.imageUrl,
// //                           width: 110,
// //                           height: 110,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             return Container(
// //                               color: Colors.grey.shade100,
// //                               child:  Icon(Icons.fastfood, size: 40, color: Colors.grey),
// //                             );
// //                           },
// //                         )
// //                       : Container(
// //                           color: Colors.grey.shade100,
// //                           child:  Icon(Icons.fastfood, size: 40, color: Colors.grey),
// //                         ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:food_delivery/const/app_colors.dart';
// import 'package:food_delivery/const/app_fonts.dart';
// import 'package:food_delivery/models/productmodel.dart';
// import 'package:food_delivery/models/offermodel.dart' hide ProductModel;

// class ProductCard extends StatelessWidget {
//   final ProductModel product;
//   final OfferModel? offer; // ✅ optional linked offer
//   final VoidCallback? onTap;

//   const ProductCard({
//     super.key,
//     required this.product,
//     this.offer,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 155,
//         height: 220,
//         margin: const EdgeInsets.only(top: 40),
//         child: Stack(
//           alignment: Alignment.topCenter,
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               top: 40,
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 20,
//                       spreadRadius: 1,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       product.name,
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleSansRoundedStyles.bold(
//                         size: 17,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'N${product.price.toStringAsFixed(2)}',
//                       textAlign: TextAlign.center,
//                       style: GoogleSansRoundedStyles.bold(
//                         color: AppColor.primary,
//                         size: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // ✅ Show offer badge if offer is passed
//                     if (offer != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.redAccent,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "${offer!.title} - ${offer!.discountPercent}% OFF",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               child: Container(
//                 width: 110,
//                 height: 110,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 15,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: product.imageUrl.isNotEmpty
//                       ? Image.network(
//                           product.imageUrl,
//                           width: 110,
//                           height: 110,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: Colors.grey.shade100,
//                               child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
//                             );
//                           },
//                         )
//                       : Container(
//                           color: Colors.grey.shade100,
//                           child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/home/view/ProductDetailScreen.dart';
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
          margin: const EdgeInsets.only(top: 40),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Card Base Container
              Positioned(
                top: 40,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
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
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Product Name
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
                      const SizedBox(height: 8),

                      // Dynamic Price Rendering
                      if (activeOffer != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'N${originalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'N${finalPrice.toStringAsFixed(0)}',
                              style: GoogleSansRoundedStyles.bold(
                                color: AppColor.primary,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Offer Badge Label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA4A0C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${activeOffer.discountPercent.toInt()}% OFF",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'N${originalPrice.toStringAsFixed(0)}',
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

              // Round Image Overlay
              Positioned(
                top: 0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.fastfood,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.fastfood,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
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