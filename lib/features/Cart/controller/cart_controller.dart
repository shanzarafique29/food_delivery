import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final RxList<ProductModel> cartItems = <ProductModel>[].obs;
  final RxMap<String, int> quantities = <String, int>{}.obs;
  final RxSet<String> selectedItemKeys = <String>{}.obs;

  final RxDouble deliveryFee = 0.0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cartSub;
  StreamSubscription<User?>? _authSub;

  String _key(ProductModel product) {
    if (product.id != null && product.id!.isNotEmpty) {
      return product.id!;
    }
    return product.name;
  }

  String keyFor(ProductModel product) => _key(product);

  void selectOnly(String key) {
    selectedItemKeys.value = {key};
  }

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

  @override
  void onInit() {
    super.onInit();

    _authSub = _auth.authStateChanges().listen((user) {
      _cartSub?.cancel();
      _cartSub = null;

      cartItems.clear();
      quantities.clear();
      selectedItemKeys.clear();

      if (user != null) {
        _bindCartStream();
      }
    });

    if (_auth.currentUser != null) {
      _bindCartStream();
    }
  }

  void _bindCartStream() {
    _cartSub?.cancel();

    final user = _auth.currentUser;

    if (user == null) {
      cartItems.clear();
      quantities.clear();
      selectedItemKeys.clear();
      return;
    }

    _cartSub = _cartCollection.snapshots().listen(
      (snapshot) {
        final List<ProductModel> loadedProducts = [];
        final Map<String, int> loadedQuantities = {};
        final Set<String> currentKeys = {};

        for (final doc in snapshot.docs) {
          final data = doc.data();

          final ProductModel product = ProductModel(
            id: data['productId']?.toString() ?? doc.id,
            name: data['name']?.toString() ?? '',
            price: _parsePrice(data['price']),
            imageUrl: data['imageUrl']?.toString() ?? '',
            category: data['category']?.toString() ?? '',
            description: data['description']?.toString() ?? '',
            offerId: data['offerId']?.toString(),
            categoryId: data['categoryId']?.toString(),
            deliveryInfo: data['deliveryInfo']?.toString(),
            termsPolicy: data['termsPolicy']?.toString(),
            isFreeDelivery: data['isFreeDelivery'] == true,
            freeDeliveryNotice: data['freeDeliveryNotice']?.toString(),
            deliveryFee: _parsePrice(data['deliveryFee']),
          );

          final String key = _key(product);

          loadedProducts.add(product);

          loadedQuantities[key] =
              (data['quantity'] as num?)?.toInt() ?? 1;

          currentKeys.add(key);
        }
        selectedItemKeys.removeWhere(
          (key) => !currentKeys.contains(key),
        );

        cartItems.assignAll(loadedProducts);
        quantities.assignAll(loadedQuantities);
      },
      onError: (error) {
        Get.snackbar(
          'Error',
          'Unable to fetch cart items: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void toggleSelection(ProductModel product) {
    final String key = _key(product);

    if (selectedItemKeys.contains(key)) {
      selectedItemKeys.remove(key);
    } else {
      selectedItemKeys.add(key);
    }
  }

  bool isSelected(ProductModel product) {
    return selectedItemKeys.contains(_key(product));
  }

  bool get isAllSelected {
    if (cartItems.isEmpty) {
      return false;
    }

    return cartItems.every(
      (product) => selectedItemKeys.contains(_key(product)),
    );
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      selectedItemKeys.clear();
    } else {
      selectedItemKeys.assignAll(
        cartItems.map((product) => _key(product)),
      );
    }
  }

  double get selectedSubtotal {
    double total = 0.0;

    for (final product in cartItems) {
      if (isSelected(product)) {
        total += product.price * getQuantity(product);
      }
    }

    return total;
  }

  double get selectedDeliveryFee {
    double total = 0.0;

    for (final product in cartItems) {
      if (!isSelected(product)) {
        continue;
      }

      if (product.isFreeDelivery == true) {
        continue;
      }

      total += product.deliveryFee ?? 0.0;
    }

    return total;
  }

  double get finalTotal {
    if (selectedItemKeys.isEmpty) {
      return 0.0;
    }

    return selectedSubtotal + selectedDeliveryFee;
  }

  List<Map<String, dynamic>> get selectedCartItemsList {
    return cartItems
        .where((product) => isSelected(product))
        .map((product) {
      final int quantity = getQuantity(product);
      final double itemPrice = product.price * quantity;

      final double itemDeliveryFee =
          product.isFreeDelivery == true
              ? 0.0
              : (product.deliveryFee ?? 0.0);

      return {
        'productId': product.id ?? '',
        'id': product.id ?? '',
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'description': product.description,
        'offerId': product.offerId,
        'categoryId': product.categoryId,
        'deliveryInfo': product.deliveryInfo ?? '',
        'termsPolicy': product.termsPolicy ?? '',
        'isFreeDelivery': product.isFreeDelivery ?? false,
        'freeDeliveryNotice': product.freeDeliveryNotice ?? '',
        'deliveryFee': itemDeliveryFee,
        'itemDeliveryFee': itemDeliveryFee,
        'quantity': quantity,
        'itemSubtotal': itemPrice,
        'totalPrice': itemPrice,
        'itemGrandTotal': itemPrice + itemDeliveryFee,
      };
    }).toList();
  }

  Future<void> addToCart(ProductModel product) async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'Login Required',
        'Please login to add items to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final String key = _key(product);

    try {
      if (quantities.containsKey(key)) {
        final int newQuantity = quantities[key]! + 1;
        selectedItemKeys.add(key);

        quantities[key] = newQuantity;

        await _cartCollection.doc(key).update({
          'quantity': newQuantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        selectedItemKeys.add(key);

        await _cartCollection.doc(key).set({
          'productId': product.id ?? key,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'description': product.description,
          'offerId': product.offerId,
          'categoryId': product.categoryId,
          'deliveryInfo': product.deliveryInfo ?? '',
          'termsPolicy': product.termsPolicy ?? '',
          'isFreeDelivery': product.isFreeDelivery ?? false,
          'freeDeliveryNotice': product.freeDeliveryNotice ?? '',
          'deliveryFee': product.isFreeDelivery == true
              ? 0.0
              : (product.deliveryFee ?? 0.0),
          'quantity': 1,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> increaseQuantity(ProductModel product) async {
    final String key = _key(product);

    if (!quantities.containsKey(key)) {
      return;
    }

    try {
      final int newQuantity = quantities[key]! + 1;

      quantities[key] = newQuantity;

      await _cartCollection.doc(key).update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to increase quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> decreaseQuantity(ProductModel product) async {
    final String key = _key(product);

    if (!quantities.containsKey(key)) {
      return;
    }

    final int quantity = quantities[key]!;

    try {
      if (quantity > 1) {
        final int newQuantity = quantity - 1;

        quantities[key] = newQuantity;

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
        'Unable to decrease quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    final String key = _key(product);

    try {
      await _cartCollection.doc(key).delete();

      cartItems.removeWhere((item) => _key(item) == key);
      quantities.remove(key);
      selectedItemKeys.remove(key);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to remove item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  int getQuantity(ProductModel product) {
    return quantities[_key(product)] ?? 0;
  }

  double getProductDeliveryFee(ProductModel product) {
    if (product.isFreeDelivery == true) {
      return 0.0;
    }

    return product.deliveryFee ?? 0.0;
  }

  double _parsePrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  @override
  void onClose() {
    _cartSub?.cancel();
    _authSub?.cancel();
    super.onClose();
  }
}