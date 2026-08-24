import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:shimmer/shimmer.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;

  const OfferCard({super.key, required this.offer});

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: offer.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${offer.code} copied!'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: offer.imageUrl!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey.shade100,
                child:  Icon(Icons.local_offer_outlined, size: 32, color: Colors.grey),
              ),
            ),
          Padding(
            padding:  EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColor.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child:  Icon(Icons.local_offer_rounded, color: AppColor.primary),
                ),
                 SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(offer.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          if (offer.isFeatured)
                             Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.star, color: Colors.orange, size: 14)),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${offer.discountPercent.toInt()}% off'
                        '${offer.minOrderAmount > 0 ? ' on orders above ₦${offer.minOrderAmount.toStringAsFixed(0)}' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      if (offer.description != null && offer.description!.isNotEmpty)
                        Padding(
                          padding:  EdgeInsets.only(top: 4),
                          child: Text(offer.description!, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyCode(context),
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(offer.code, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                         SizedBox(width: 4),
                        Icon(Icons.copy, color: Colors.white, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}