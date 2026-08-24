import 'package:food_delivery/models/offermodel.dart' hide ProductModel;
import 'package:food_delivery/models/productmodel.dart';

class OfferHelper {
  static OfferModel? findActiveOffer(
    List<OfferModel> offers,
    ProductModel product,
  ) {
    final now = DateTime.now();
    for (final o in offers) {
      if (!o.isActive) continue;
      if (o.expiryDate != null && o.expiryDate!.isBefore(now)) continue;

      final matchesProduct = o.productId != null && o.productId == product.id;
      final matchesCategory =
          o.categoryId != null && o.categoryId == product.categoryId;
      final matchesDirectOffer =
          product.offerId != null && o.id == product.offerId;

      if (matchesProduct || matchesCategory || matchesDirectOffer) {
        return o;
      }
    }
    return null;
  }

  static double getFinalPrice(double originalPrice, OfferModel? offer) {
    if (offer == null) return originalPrice;
    return originalPrice * (1 - (offer.discountPercent / 100));
  }
}