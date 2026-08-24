import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/cart/controller/cart_controller.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/features/home/controller/home_controller.dart';
import 'package:food_delivery/features/home/widgets/product_detail_content.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  late final CartController cartController;
  late final FavoriteController favoriteController;
  late final MyOffersController offersController;

  List<ProductModel> _categoryProducts = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    favoriteController = Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController());

    offersController = Get.isRegistered<MyOffersController>()
        ? Get.find<MyOffersController>()
        : Get.put(MyOffersController());

    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      final currentCat = widget.product.category.trim().toLowerCase();

      _categoryProducts = homeController.allProducts.where((p) {
        final prodCat = p.category.trim().toLowerCase();
        final matchCatName =
            prodCat == currentCat || prodCat.contains(currentCat);
        final matchCatId = widget.product.categoryId != null &&
            p.categoryId == widget.product.categoryId;
        return matchCatName || matchCatId;
      }).toList();
    }

    if (_categoryProducts.isEmpty) {
      _categoryProducts = [widget.product];
    }

    _currentIndex =
        _categoryProducts.indexWhere((p) => p.id == widget.product.id);
    if (_currentIndex == -1) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final currentProduct = _categoryProducts[_currentIndex];
            final isFav = favoriteController.isFavorite(currentProduct);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColor.primary : Colors.black,
              ),
              onPressed: () =>
                  favoriteController.toggleFavorite(currentProduct),
            );
          }),
           SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_categoryProducts.length > 1)
              Padding(
                padding:  EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_categoryProducts.length, (index) {
                    return AnimatedContainer(
                      duration:  Duration(milliseconds: 250),
                      margin:  EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 10 : 8,
                      height: _currentIndex == index ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppColor.primary
                            : Colors.grey.shade500,
                      ),
                    );
                  }),
                ),
              ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _categoryProducts.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final product = _categoryProducts[index];
                  return ProductDetailContent(
                    product: product,
                    cartController: cartController,
                    offersController: offersController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}