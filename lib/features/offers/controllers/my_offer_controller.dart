import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:get/get.dart';

class MyOffersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<OfferModel> offersList = <OfferModel>[].obs;
  RxList<OfferModel> featuredOffers = <OfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    offersList.bindStream(listenToOffers());
  }

  /// ✅ Listen to active + non-expired offers (works offline too)
  Stream<List<OfferModel>> listenToOffers() {
    return _firestore
        .collection('offers')
        .where('isActive', isEqualTo: true)
        .snapshots(includeMetadataChanges: true) // ✅ include cache + server updates
        .map((snap) {
          final all = snap.docs.map((doc) => OfferModel.fromSnapshot(doc)).toList();

          final now = DateTime.now();

          // ✅ filter expired offers
          final validOffers = all.where((offer) {
            if (offer.expiryDate != null) {
              return offer.expiryDate!.isAfter(now);
            }
            return true;
          }).toList();

          // ✅ separate featured offers
          featuredOffers.value = validOffers.where((o) => o.isFeatured).toList();

          return validOffers;
        });
  }

  /// ✅ Get offers for a specific product
  List<OfferModel> getOffersForProduct(String productId) {
    return offersList.where((offer) {
      return offer.productId != null && offer.productId == productId;
    }).toList();
  }
}
