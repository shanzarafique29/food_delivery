import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:food_delivery/models/productmodel.dart';

class CartController extends GetxController {
  final RxList<ProductModel> cartItems = <ProductModel>[].obs;

  final RxMap<String, int> quantities = <String, int>{}.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _key(ProductModel product) {
    return product.id ?? product.name;
  }

  // ============================================================
  // FIRESTORE CART COLLECTION
  // users/{uid}/cart
  // ============================================================

  CollectionReference<Map<String, dynamic>> get _cartCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart');
  }

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart(ProductModel product) async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'Login required',
        'Please login before adding items to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final key = _key(product);

    try {
      // Already exists
      if (quantities.containsKey(key)) {
        final newQuantity = quantities[key]! + 1;

        quantities[key] = newQuantity;

        await _cartCollection.doc(key).update({
          'quantity': newQuantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // New product
      else {
        cartItems.add(product);
        quantities[key] = 1;

        await _cartCollection.doc(key).set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'description': product.description,
          'quantity': 1,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      quantities.refresh();
      cartItems.refresh();

      Get.snackbar(
        'Cart',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  Future<void> increaseQuantity(ProductModel product) async {
    final key = _key(product);

    if (!quantities.containsKey(key)) return;

    try {
      final newQuantity = quantities[key]! + 1;

      quantities[key] = newQuantity;
      quantities.refresh();

      await _cartCollection.doc(key).update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  Future<void> decreaseQuantity(ProductModel product) async {
    final key = _key(product);

    if (!quantities.containsKey(key)) return;

    final quantity = quantities[key]!;

    try {
      if (quantity > 1) {
        final newQuantity = quantity - 1;

        quantities[key] = newQuantity;
        quantities.refresh();

        await _cartCollection.doc(key).update({
          'quantity': newQuantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await removeFromCart(product);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // REMOVE FROM CART
  // ============================================================

  Future<void> removeFromCart(ProductModel product) async {
    final key = _key(product);

    try {
      await _cartCollection.doc(key).delete();

      cartItems.removeWhere(
        (item) => _key(item) == key,
      );

      quantities.remove(key);

      cartItems.refresh();
      quantities.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to remove item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // GET QUANTITY
  // ============================================================

  int getQuantity(ProductModel product) {
    return quantities[_key(product)] ?? 0;
  }

  // ============================================================
  // TOTAL PRICE
  // ============================================================

  double get totalPrice {
    double total = 0;

    for (final product in cartItems) {
      total += product.price * getQuantity(product);
    }

    return total;
  }

  // ============================================================
  // LOAD CART FROM FIRESTORE
  // ============================================================

  Future<void> loadCart() async {
    final user = _auth.currentUser;

    if (user == null) {
      cartItems.clear();
      quantities.clear();
      return;
    }

    try {
      final snapshot = await _cartCollection.get();

      final List<ProductModel> loadedProducts = [];
      final Map<String, int> loadedQuantities = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final product = ProductModel(
          id: data['productId']?.toString() ?? doc.id,
          name: data['name']?.toString() ?? '',
          price: _parsePrice(data['price']),
          imageUrl: data['imageUrl']?.toString() ?? '',
          category: data['category']?.toString() ?? '',
          description: data['description']?.toString() ?? '',
        );

        final key = _key(product);

        loadedProducts.add(product);

        loadedQuantities[key] =
            (data['quantity'] as num?)?.toInt() ?? 1;
      }

      cartItems.assignAll(loadedProducts);
      quantities.assignAll(loadedQuantities);

      cartItems.refresh();
      quantities.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    final user = _auth.currentUser;

    if (user == null) {
      cartItems.clear();
      quantities.clear();
      return;
    }

    try {
      final snapshot = await _cartCollection.get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Memory cart bhi clear
      cartItems.clear();
      quantities.clear();

      cartItems.refresh();
      quantities.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to clear cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // PRICE CONVERTER
  // ============================================================

  double _parsePrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
}