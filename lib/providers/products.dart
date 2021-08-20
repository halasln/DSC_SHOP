import 'package:flutter/material.dart';
import 'package:dsc_shop/models/product.dart';
import 'dart:collection';

class Products extends ChangeNotifier {
  List<Product> _productList = [];
  // List<Product> _matchedProducts = [];
  // bool _searching = false;

  UnmodifiableListView<Product> get allProducts {
    return UnmodifiableListView(_productList);
  }

  void setAllProducts(productsFromApi) {
    _productList = productsFromApi;
    notifyListeners();
  }

  int get productsCount {
    return _productList.length;
  }

  UnmodifiableListView<Product> get matchedProducts {
    return UnmodifiableListView(_productList);
  }

  // void setMatchedProducts(List<Product> products) {
  //   _matchedProducts = products;
  //   notifyListeners();
  // }

  // int get matchedProductsCount {
  //   return _matchedProducts.length;
  // }

  // bool get isSearching {
  //   return _searching;
  // }

  // void search() {
  //   _searching = true;
  // }

  // notSearch() {
  //   _searching = false;
  // }
}
