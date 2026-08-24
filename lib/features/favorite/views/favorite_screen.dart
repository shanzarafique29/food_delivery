import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/favorite/widgets/favorite_item_card.dart';
import 'package:food_delivery/features/home/view/root_screen.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/utils/offer_helper.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FavoriteController favoriteController =
        Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController());
    final MyOffersController offersController =
        Get.isRegistered<MyOffersController>()
        ? Get.find<MyOffersController>()
        : Get.put(MyOffersController());

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Favorites",
          style: GoogleSansRoundedStyles.bold(
            size: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            if (favoriteController.favoriteList.isEmpty) {
              return const SizedBox();
            }
            return TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Clear Favorites?",
                  middleText:
                      "Are you sure you want to remove all favorite items?",
                  textConfirm: "Clear",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: AppColor.primary,
                  onConfirm: () {
                    favoriteController.clearAllFavorites();
                    Get.back();
                  },
                );
              },
              child: Text(
                "Clear All",
                style: GoogleSansRoundedStyles.medium(
                  size: 14,
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (favoriteController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (favoriteController.favoriteList.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 60,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Favorites Yet",
                    style: GoogleSansRoundedStyles.bold(
                      size: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Tap the heart icon on any food item to save your favorite dishes here for quick ordering.",
                    textAlign: TextAlign.center,
                    style: GoogleSansRoundedStyles.regular(
                      size: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 28),
                  SizedBox(
  width: 180,
  height: 48,
  child: ElevatedButton(
    onPressed: () {
      print("Button clicked");

     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
    ),
    child: Text(
      "Explore Menu",
      style: GoogleSansRoundedStyles.medium(
        size: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: favoriteController.favoriteList.length,
          itemBuilder: (context, index) {
            final product = favoriteController.favoriteList[index];
            final linkedOffer = OfferHelper.findActiveOffer(
              offersController.offersList,
              product,
            );

            return FavoriteItemCard(
              product: product,
              linkedOffer: linkedOffer,
              favoriteController: favoriteController,
            );
          },
        );
      }),
    );
  }
}
