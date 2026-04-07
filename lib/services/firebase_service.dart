import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() {
    return _instance;
  }
  
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth Methods
  Future<UserCredential> registerWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> loginWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // User Firestore Methods
  Future<void> createUserDocument(String userId, UserModel user) async {
    try {
      await _firestore.collection('users').doc(userId).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserDocument(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserDocument(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Wishlist Methods
  Future<void> addToWishlist(String userId, String productId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlist': FieldValue.arrayUnion([productId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlist': FieldValue.arrayRemove([productId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Storage Methods
  Future<String> uploadImage(String path, String fileName) async {
    try {
      final ref = _storage.ref().child('products/$fileName');
      await ref.putFile(path as dynamic);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      rethrow;
    }
  }
}
