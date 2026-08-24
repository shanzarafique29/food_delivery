import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:get/get.dart';

class MyOffersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<OfferModel> offersList = <OfferModel>[].obs;
  RxList<OfferModel> promoCodesList = <OfferModel>[].obs;

  var isLoadingPromos = true.obs;
  var promoError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _firestore.collection('offers').where('isActive', isEqualTo: true).snapshots().listen(
      (snapshot) {
        final now = DateTime.now();
        offersList.value = snapshot.docs
            .map((doc) => OfferModel.fromSnapshot(doc))
            .where((o) => o.expiryDate == null || o.expiryDate!.isAfter(now))
            .toList();
      },
      onError: (e) => debugPrint('offersList stream error: $e'),
    );

    _firestore
        .collection('offers')
        .where('isActive', isEqualTo: true)
        .where('requiresCode', isEqualTo: true)
        .snapshots()
        .listen(
      (snapshot) {
        final now = DateTime.now();
        promoCodesList.value = snapshot.docs
            .map((doc) => OfferModel.fromSnapshot(doc))
            .where((o) => o.expiryDate == null || o.expiryDate!.isAfter(now)) 
            .toList();
        isLoadingPromos.value = false;
        promoError.value = null;
      },
      onError: (e) {
        debugPrint('MyOffers stream error: $e');
        promoError.value = e.toString();
        isLoadingPromos.value = false;
      },
    );
  }

  Future<OfferModel?> validatePromoCode(String code, double subtotal) async {
    final snapshot = await _firestore
        .collection('offers')
        .where('code', isEqualTo: code.trim().toUpperCase())
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final offer = OfferModel.fromSnapshot(snapshot.docs.first);

    if (offer.expiryDate != null && offer.expiryDate!.isBefore(DateTime.now())) return null;
    if (subtotal < offer.minOrderAmount) return null;

    return offer;
  }
}