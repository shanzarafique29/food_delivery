import 'package:flutter/material.dart';
import 'package:food_delivery/features/home/controller/food_searchcontroller.dart';
import 'package:food_delivery/widgets/product_card.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodSearchController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon:  Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      onSubmitted: (value) => controller.performSearch(value),
                      onChanged: (value) {
    
                        controller.updateSuggestions(value);
                      },
                      decoration:  InputDecoration(
                        hintText: 'Search food...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      style:  TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(() => controller.isSearching.value
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchResults.clear();
                            controller.suggestions.clear();
                            controller.isSearching.value = false;
                          },
                        )
                      :  SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  String query = controller.searchController.text.trim();
                  final isSearching = controller.isSearching.value;
                  final suggestions = controller.suggestions;
                  final results = controller.searchResults;
                  final history = controller.searchHistory;

                  if (query.isNotEmpty && suggestions.isNotEmpty && results.isEmpty) {
                    return ListView.separated(
                      itemCount: suggestions.length,
                      separatorBuilder: (_, _) =>  Divider(height: 1, color: Colors.black12),
                      itemBuilder: (context, index) {
                        final item = suggestions[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          leading:  Icon(Icons.search, color: Colors.grey),
                          title: Text(
                            item.name,
                            style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing:  Icon(Icons.north_west, size: 16, color: Colors.grey),
                          onTap: () {
                            controller.performSearch(item.name);
                          },
                        );
                      },
                    );
                  }
                  if (query.isEmpty || !isSearching) {
                    if (history.isEmpty) {
                      return  Center(
                        child: Text(
                          'Type to search items',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () => controller.clearHistory(),
                              child:  Text('Clear all', style: TextStyle(color: Colors.red)),
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
                                leading:  Icon(Icons.history, color: Colors.grey),
                                title: Text(item),
                                trailing: IconButton(
                                  icon:  Icon(Icons.close, size: 18, color: Colors.grey),
                                  onPressed: () => controller.removeFromHistory(index),
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
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                           SizedBox(height: 10),
                           Text(
                            'Try searching the item with\na different keyword.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                           SizedBox(height: 60),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding:  EdgeInsets.only(top: 10, bottom: 20),
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
      ),
    );
  }
}