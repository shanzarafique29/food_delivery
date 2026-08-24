import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/models/offermodel.dart' hide ProductModel;
import 'package:food_delivery/models/productmodel.dart';

class ProductPriceSection extends StatelessWidget {
  final ProductModel product;
  final OfferModel? activeOffer;
  final double finalPrice;

  const ProductPriceSection({
    super.key,
    required this.product,
    required this.activeOffer,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final originalPrice = product.price;
    final isFreeDelivery = product.isFreeDelivery ?? false;
    final deliveryFee = product.deliveryFee ?? 0;

    return Column(
      children: [
        if (activeOffer != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PKR ${originalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PKR ${finalPrice.toStringAsFixed(0)}',
                style: GoogleSansRoundedStyles.bold(
                  color: AppColor.primary,
                  size: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ] else ...[
          Text(
            'PKR ${originalPrice.toStringAsFixed(0)}',
            style: GoogleSansRoundedStyles.bold(
              color: AppColor.primary,
              size: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
         SizedBox(height: 8),

        Container(
          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isFreeDelivery
                ? AppColor.text2.withValues(alpha: 0.15)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFreeDelivery
                  ? AppColor.text2
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_shipping_rounded,
                color: isFreeDelivery
                    ? AppColor.text2
                    : Colors.grey.shade600,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                isFreeDelivery
                    ? 'Free Delivery Available'
                    : 'Delivery fee: PKR ${deliveryFee.toStringAsFixed(0)}',
                style: TextStyle(
                  color: isFreeDelivery
                      ?  AppColor.text2
                      : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}