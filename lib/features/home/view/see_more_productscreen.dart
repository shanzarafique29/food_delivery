import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/home/controller/home_controller.dart';
import 'package:food_delivery/widgets/product_card.dart';
import 'package:get/get.dart';

class SeeMoreProductsScreen extends StatelessWidget {
  const SeeMoreProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final selectedCategory =
              controller.categories[controller.selectedCategoryIndex.value];
          return Text(
            selectedCategory,
            style: GoogleSansRoundedStyles.light(
              size: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            )
          );
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final list = controller.filteredProducts;

        if (list.isEmpty) {
          return  Center(
            child: Text(
              'No products available in this category',
              style:  GoogleSansRoundedStyles.light(
                  size: 18,
                  color:  Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Text(
                'Found ${list.length} results',
                style: GoogleSansRoundedStyles.light(
                  size: 18,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              MasonryGridView.count(
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  bool isEven = index % 2 == 0;
                  return Padding(
                    padding: EdgeInsets.only(top: isEven ? 0 : 40),
                    child: SizedBox(
                      height:
                          300,
                      child: ProductCard(product: list[index], onTap: () {}),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
