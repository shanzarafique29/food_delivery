import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodSearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GetStorage? _storage;

  final TextEditingController searchController = TextEditingController();

  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  RxList<ProductModel> suggestions = <ProductModel>[].obs; 
  RxList<String> searchHistory = <String>[].obs;

  RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initStorageAndData();
  }

  void _initStorageAndData() {
    try {
      _storage = GetStorage();
      loadSearchHistory();
    } catch (e) {
      debugPrint("GetStorage error: $e");
    }
    fetchProducts();
  }

  void fetchProducts() {
    _firestore.collection('products').snapshots().listen((snapshot) {
      allProducts.value = snapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
    });
  }

  void loadSearchHistory() {
    if (_storage == null) return;
    try {
      var savedHistory = _storage!.read('searchHistory');
      if (savedHistory != null && savedHistory is List) {
        searchHistory.value = List<String>.from(savedHistory);
      }
    } catch (e) {
      debugPrint("History load error: $e");
    }
  }

  void updateSuggestions(String query) {
    if (query.trim().isEmpty) {
      suggestions.clear();
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    searchResults.clear(); 
    String q = query.toLowerCase().trim();

    suggestions.value = allProducts.where((product) {
      return product.name.toLowerCase().contains(q) ||
          product.category.toLowerCase().contains(q);
    }).toList();
  }

  void performSearch(String query) {
    if (query.trim().isEmpty) {
      searchResults.clear();
      suggestions.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    String q = query.toLowerCase().trim();

    searchResults.value = allProducts.where((product) {
      return product.name.toLowerCase().contains(q) ||
          product.category.toLowerCase().contains(q) ||
          product.description.toLowerCase().contains(q);
    }).toList();

    suggestions.clear(); 
    saveToHistory(query.trim());
  }

  void saveToHistory(String query) {
    if (query.isEmpty || _storage == null) return;

    searchHistory.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    searchHistory.insert(0, query);

    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }

    _storage!.write('searchHistory', searchHistory.toList());
  }

  void removeFromHistory(int index) {
    if (_storage == null) return;
    searchHistory.removeAt(index);
    _storage!.write('searchHistory', searchHistory.toList());
  }

  void clearHistory() {
    if (_storage == null) return;
    searchHistory.clear();
    _storage!.remove('searchHistory');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}