import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  
  factory ProductService() {
    return _instance;
  }
  
  ProductService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create product
  Future<String> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection('products').add(product.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get product by ID
  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Stream all products
  Stream<List<ProductModel>> streamAllProducts() {
    try {
      return _firestore.collection('products').snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get products by vendor
  Future<List<ProductModel>> getProductsByVendor(String vendorId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('vendorId', isEqualTo: vendorId)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Search products by name
  Future<List<ProductModel>> searchProductsByName(String query) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get products with price range filter
  Future<List<ProductModel>> getProductsByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('products').doc(productId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get discounted products
  Future<List<ProductModel>> getDiscountedProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('discount', isGreaterThan: 0)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get best rated products
  Future<List<ProductModel>> getBestRatedProducts({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get newest products
  Future<List<ProductModel>> getNewestProducts({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Apply discount to product
  Future<void> applyDiscount(
    String productId,
    double discountPercent,
    DateTime discountEndDate,
  ) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'discount': discountPercent,
        'discountEndDate': discountEndDate,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Remove discount from product
  Future<void> removeDiscount(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'discount': null,
        'discountEndDate': null,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }
}