import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/home/controller/food_searchcontroller.dart';
import 'package:food_delivery/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodSearchController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isOffline.value) {
            return _buildNoInternetView(controller);
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        autofocus: true,
                        onSubmitted: (value) => controller.performSearch(value),
                        onChanged: (value) =>
                            controller.updateSuggestions(value),
                        decoration: InputDecoration(
                          hintText: 'Search food...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        style: GoogleSansRoundedStyles.light(
                          size: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.isSearching.value
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.searchResults.clear();
                                controller.suggestions.clear();
                                controller.isSearching.value = false;
                              },
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildShimmerGrid();
                    }

                    String query = controller.searchController.text.trim();
                    final isSearching = controller.isSearching.value;
                    final suggestions = controller.suggestions;
                    final results = controller.searchResults;
                    final history = controller.searchHistory;

                    if (query.isNotEmpty &&
                        suggestions.isNotEmpty &&
                        results.isEmpty) {
                      return ListView.separated(
                        itemCount: suggestions.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.black12),
                        itemBuilder: (context, index) {
                          final item = suggestions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            leading: Icon(Icons.search, color: Colors.grey),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              Icons.north_west,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              controller.performSearch(item.name);
                            },
                          );
                        },
                      );
                    }
                    if (query.isEmpty || !isSearching) {
                      if (history.isEmpty) {
                        return Center(
                          child: Text(
                            'Type to search items',
                            style: GoogleSansRoundedStyles.regular(
                              size: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Searches',
                                style: GoogleSansRoundedStyles.regular(
                                  size: 16,
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              TextButton(
                                onPressed: () => controller.clearHistory(),
                                child: Text(
                                  'Clear all',
                                  style: GoogleSansRoundedStyles.light(
                                    size: 16,
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: history.length,
                              itemBuilder: (context, index) {
                                final item = history[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    Icons.history,
                                    color: Colors.grey,
                                  ),
                                  title: Text(item),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () =>
                                        controller.removeFromHistory(index),
                                  ),
                                  onTap: () {
                                    controller.performSearch(item);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    if (results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 110,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Item not found',
                              style: GoogleSansRoundedStyles.medium(
                                size: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Try searching the item with\na different keyword.',
                              textAlign: TextAlign.center,
                              style: GoogleSansRoundedStyles.thin(
                                size: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w100,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 60),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: results[index],
                          onTap: () {},
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 15,
                  width: 120,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  height: 20,
                  width: 60,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoInternetView(FoodSearchController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 120, color: Colors.grey.shade400),
          SizedBox(height: 30),
          Text(
            'No internet Connection',
            style: GoogleSansRoundedStyles.regular(
              size: 22,
              color: Colors.black,
              fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Your internet connection is currently\nnot available please check or try again.',
            textAlign: TextAlign.center,
            style: GoogleSansRoundedStyles.thin(
              size: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => controller.retryConnection(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: TextButton(
                onPressed: () => controller.retryConnection(),
                child: Text(
                  'Try again',
                  style: GoogleSansRoundedStyles.bold(
                    size: 18,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
