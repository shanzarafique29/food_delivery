import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<String> categories = <String>[].obs;
  var selectedCategoryIndex = 0.obs;

  Worker? _categoriesWorker;

  @override
  void onInit() {
    super.onInit();
    allProducts.bindStream(
      _firestore
          .collection('products')
          .snapshots(includeMetadataChanges: true)
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => ProductModel.fromSnapshot(doc))
                .toList(),
          ),
    );

    categories.bindStream(
      _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .snapshots(includeMetadataChanges: true)
          .map(
            (snapshot) => snapshot.docs
                .map((doc) {
                  final data = doc.data();
                  return (data['name'] ?? '').toString();
                })
                .where((name) => name.isNotEmpty)
                .toList(),
          ),
    );
    _categoriesWorker = ever(categories, (_) {
      if (categories.isEmpty) return;
      if (selectedCategoryIndex.value >= categories.length) {
        selectedCategoryIndex.value = 0;
      }
    });
  }

  List<ProductModel> get filteredProducts {
    if (categories.isEmpty ||
        selectedCategoryIndex.value >= categories.length) {
      return [];
    }

    String selectedCategory = categories[selectedCategoryIndex.value]
        .trim()
        .toLowerCase();

    return allProducts.where((product) {
      String prodCat = product.category.trim().toLowerCase();
      return prodCat == selectedCategory || prodCat.contains(selectedCategory);
    }).toList();
  }

  @override
  void onClose() {
    _categoriesWorker?.dispose();
    super.onClose();
  }
}