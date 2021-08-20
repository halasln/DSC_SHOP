import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  final String uid;
  FirestoreDatabase({required this.uid});

  Future<void> setUserData(data) async {
    final path = '/users/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Future getUserData() async {
    final path = '/users/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    final snapshot = await documentReference.get();
    return snapshot.data();
  }

  Future<void> updateUserFavorite(data) async {
    final path = '/favorite/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Future getUserfavorite() async {
    final path = '/favorite/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    final snapshot = await documentReference.get();
    return snapshot.data();
  }

  Future<void> updateUserCart(data) async {
    final path = '/cart/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Future getUsercart() async {
    final path = '/cart/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    final snapshot = await documentReference.get();
    return snapshot.data();
  }

  Future<void> updateProductsQuantity(data) async {
    final path = '/quantity/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Future getProductsQuantity() async {
    final path = '/quantity/$uid/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    final snapshot = await documentReference.get();
    return snapshot.data();
  }
}
