import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/home/controller/ZoomDrawerController.dart';
import 'package:food_delivery/features/home/controller/home_controller.dart';
import 'package:food_delivery/features/home/view/searchscreen.dart';
import 'package:food_delivery/features/home/view/see_more_productscreen.dart';
import 'package:food_delivery/widgets/product_card.dart';
import 'package:food_delivery/widgets/customappbar.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(Icons.notes, size: 28, color: Colors.black),
          onPressed: () {
             Get.find<MainDrawerController>().toggleDrawer();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 26,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delicious\nfood for you',
                style: GoogleSansRoundedStyles.thin(
                  size: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              SizedBox(height: size.height * 0.02),

              GestureDetector(
                onTap: () => Get.to(() => SearchScreen()),
                behavior: HitTestBehavior.opaque,
                child: AbsorbPointer(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFEEFC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          'Search',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                height: 45,
                child: Obx(() {
                  final activeIndex = controller.selectedCategoryIndex.value;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final isSelected = activeIndex == index;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            controller.selectedCategoryIndex.value = index,
                        child: Padding(
                          padding: EdgeInsets.only(right: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.categories[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.grey.shade400,
                                ),
                              ),
                              SizedBox(height: 6),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 4,
                                width: isSelected ? 40 : 0,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => SeeMoreProductsScreen());
                  },
                  child: Text(
                    'see more',
                    style: GoogleSansRoundedStyles.thin(
                      size: 14,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: Obx(() {
                  final list = controller.filteredProducts;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No products available in this category',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        ProductCard(product: list[index], onTap: () {}),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
