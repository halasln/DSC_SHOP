import 'package:dsc_shop/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class Cart extends ChangeNotifier {
  List _cartProducts = [];
  List _productsQuantity = [];

  UnmodifiableListView get productsInCart {
    return UnmodifiableListView(_cartProducts);
  }

  UnmodifiableListView get productsQuantity {
    return UnmodifiableListView(_productsQuantity);
  }

  void setCartProducts(List products) {
    _cartProducts = products;
    notifyListeners();
  }

  void setProductsQuantity(List products) {
    _productsQuantity = products;
    notifyListeners();
  }

  void addToCart(int id) {
    _cartProducts.add(id);
    _productsQuantity.add(1.0);
    print(_cartProducts);
    print(_productsQuantity);
    notifyListeners();
  }

  void removeFromCart(int id) {
    _productsQuantity.removeAt(_cartProducts.indexOf(id));
    _cartProducts.remove(id);
    print(_cartProducts);
    print(_productsQuantity);
    notifyListeners();
  }

  int get productsCountInCart {
    return _cartProducts.length;
  }

  increaseQuantity(int index) {
    _productsQuantity[index]++;
    print(_cartProducts);
    print(_productsQuantity);
    notifyListeners();
  }

  decreaseQuantity(int index) {
    _productsQuantity[index]--;
    print(_cartProducts);
    print(_productsQuantity);
    notifyListeners();
  }

  String? calculateTotalPrice(List<Product> all) {
    double total = 0.0;
    for (int productID in _cartProducts) {
      double price = all[productID - 1].price.runtimeType == double
          ? all[productID - 1].price
          : all[productID - 1].price.toDouble();
      double quantity = _productsQuantity[_cartProducts.indexOf(productID)];
      double itemPrice = price * quantity;
      total += itemPrice;
    }
    return total.toStringAsFixed(2);
  }
}
