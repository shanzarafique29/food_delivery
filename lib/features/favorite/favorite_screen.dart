import 'package:flutter/material.dart';
import 'package:food_delivery/features/Cart/cart_screen.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/home/view/homescreen.dart';
import 'package:food_delivery/onboarding/onboardingscreen.dart';
import 'package:get/get.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteController controller = Get.find<FavoriteController>();
  final CartController cartController = Get.put(CartController());

  final PageController pageController = PageController();

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Obx(() {
          final favorites = controller.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            );
          }

          // Agar kisi favorite ko remove kar diya aur
          // current index list se bahar chala gaya ho.
          if (currentIndex >= favorites.length) {
            currentIndex = favorites.length - 1;
          }

          final product = favorites[currentIndex];

          return Column(
            children: [

              // =========================
              // TOP BAR
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [

                    // BACK BUTTON
                    IconButton(
                      onPressed: () {
                        Get.off(() => HomeScreen());
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      'Favorites',
                      style: GoogleSansRoundedStyles.bold(
                        size: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    const SizedBox(width: 48),
                    GestureDetector(
                            onTap: () {
                              controller.toggleFavorite(product);
                            },
                            child: Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColor.primary,
                            ),
                          ),

                  ],
                ),
              ),

              // =========================
              // IMAGE + INFORMATION
              // =========================
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: favorites.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    final item = favorites[index];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 10),

                            // =========================
                            // PRODUCT IMAGE
                            // =========================
                            Container(
                              width: 230,
                              height: 230,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: item.imageUrl.isNotEmpty
                                    ? Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.fastfood,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // =========================
                            // DOTS
                            // =========================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: List.generate(
                                favorites.length,
                                (dotIndex) {
                                  final isActive =
                                      currentIndex == dotIndex;

                                  return AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    margin:
                                        const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: isActive ? 7 : 6,
                                    height: isActive ? 7 : 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive
                                          ? AppColor.primary
                                          : Colors.grey.shade300,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 22),

                            // =========================
                            // PRODUCT NAME
                            // =========================
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: GoogleSansRoundedStyles.bold(
                                size: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // =========================
                            // PRICE
                            // =========================
                            Text(
                              '₦${item.price.toStringAsFixed(0)}',
                              style: GoogleSansRoundedStyles.bold(
                                size: 16,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // =========================
                            // DELIVERY INFO
                            // =========================
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 28,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    const Text(
                                      'Delivery info',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'Delivered between monday and '
                                      'thursday 20 from 8pm to 9:32 pm',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    const Text(
                                      'Return policy',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'All our foods are double checked '
                                      'before leaving our stores so by any '
                                      'case you found a broken food please '
                                      'contact our hotline immediately.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // =========================
                            // ADD TO CART
                            // =========================
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                 onPressed: () {
                                    cartController.addToCart(product);

                                    Get.to(() => CartScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColor.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(28),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}