import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/models/productmodel.dart';


class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        height: 220,
        margin: const EdgeInsets.only(top: 40),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        size: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                     SizedBox(height: 12),
                    Text(
                      'N${product.price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: GoogleSansRoundedStyles.bold(
                        color: AppColor.primary,
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 15,
                      offset:  Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade100,
                              child:  Icon(Icons.fastfood, size: 40, color: Colors.grey),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          child:  Icon(Icons.fastfood, size: 40, color: Colors.grey),
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