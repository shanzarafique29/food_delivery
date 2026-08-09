import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<String> categories = <String>[
    'Fast Food',
    'Snacks',
    'Desi foods',
    'Burgers',
    'Pizza',
    'Drinks',
    'Desserts',
  ].obs;

  var selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    allProducts.bindStream(
      _firestore.collection('products').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => ProductModel.fromSnapshot(doc))
                .toList(),
          ),
    );
  }
  List<ProductModel> get filteredProducts {
    if (categories.isEmpty || selectedCategoryIndex.value >= categories.length) {
      return [];
    }

    String selectedCategory = categories[selectedCategoryIndex.value].trim().toLowerCase();

    return allProducts.where((product) {
      String prodCat = product.category.trim().toLowerCase();
      return prodCat == selectedCategory || prodCat.contains(selectedCategory);
    }).toList();
  }
}