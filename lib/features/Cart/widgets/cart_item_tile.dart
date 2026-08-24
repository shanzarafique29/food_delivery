import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/Cart/controller/cart_controller.dart';
import 'package:food_delivery/features/favorite/controller/favorite_controller.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CartItemTile extends StatefulWidget {
  final ProductModel product;
  final CartController cartController;

  const CartItemTile({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  double _dragOffset = 0.0;
  static const double _maxDrag = 96.0;

  void _resetDrag() => setState(() => _dragOffset = 0.0);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController());

    final product = widget.product;
    final cartController = widget.cartController;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.only(bottom: 14),
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    favoriteController.toggleFavorite(product);
                    _resetDrag();
                  },
                  child: Obx(() {
                    final isFav = favoriteController.isFavorite(product);
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isFav
                            ? AppColor.text4
                            : AppColor.text4.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.white : AppColor.text4,
                        size: 18,
                      ),
                    );
                  }),
                ),
                SizedBox(width: size.width * 0.01),
                GestureDetector(
                  onTap: () {
                    cartController.removeFromCart(product);
                    _resetDrag();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.text4,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset -= details.delta.dx;
              _dragOffset = _dragOffset.clamp(0.0, _maxDrag);
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              _dragOffset = _dragOffset > _maxDrag / 2 ? _maxDrag : 0.0;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            transform: Matrix4.translationValues(-_dragOffset, 0, 0),
            margin: EdgeInsets.only(bottom: 14),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Obx(
                  () => Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: cartController.isSelected(product),
                      activeColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (_) => cartController.toggleSelection(product),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: product.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: AppColor.background,
                            child: Container(
                              width: size.width * 0.2,
                              height: size.width * 0.2,
                              color: AppColor.background,
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: size.width * 0.2,
                            height: size.width * 0.2,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.fastfood,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          color: Colors.grey.shade200,
                          child: Image.asset(
                            'assets/images/app logo.png',
                            height: 20,
                            width: 20,
                            color: Colors.grey,
                          ),
                        ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Obx(
                        () => Text(
                          'PKR ${(product.price * cartController.getQuantity(product)).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => cartController.decreaseQuantity(product),
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Obx(
                          () => Text(
                            '${cartController.getQuantity(product)}',
                            style: GoogleSansRoundedStyles.bold(
                              color: Colors.white,
                              size: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cartController.increaseQuantity(product),
                        child: Icon(Icons.add, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
