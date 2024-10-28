import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:gestionstock/models/product.dart';

class ProductRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductRepository(this.firestore, this.storage);

  Future<void> addProduct({
    required String name,
    required String userEmail,
    required String category,
    required String description,
    required int quantity,
    required File imageFile,
  }) async {
    try {
      
      String imageUrl = await _uploadImage(imageFile);

      await firestore.collection('products').add({
        'name': name,
        'category': category,
        'description': description,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'userEmail':userEmail
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final storageRef = storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

   Future<List<Product>> fetchProducts() async {
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

   Future<Product> getProductById(String productId) async {
    final doc = await firestore.collection('products').doc(productId).get();
    if (doc.exists) {
          return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);

    } else {
      throw Exception('Product not found');
    }
  }

 
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    await firestore.collection('products').doc(productId).update({
      'quantity': newQuantity,
    });
  }

   Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }
  
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String category,
    required String description,
    required int quantity,
    required String imageUrl,
  }) async {
    await firestore.collection('products').doc(productId).update({
      'name': name,
      'category': category,
      'description': description,
      'quantity': quantity,
      'imageUrl': imageUrl,
    });
  }
}
