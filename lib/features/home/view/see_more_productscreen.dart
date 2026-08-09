import 'package:flutter/material.dart';
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final selectedCategory =
              controller.categories[controller.selectedCategoryIndex.value];
          return Text(
            selectedCategory,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          );
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final list = controller.filteredProducts;

        if (list.isEmpty) {
          return const Center(
            child: Text(
              'No products available in this category',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: list[index],
              onTap: () {},
            );
          },
        );
      }),
    );
  }
}