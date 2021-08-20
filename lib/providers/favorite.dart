import 'package:flutter/material.dart';
import 'dart:collection';

class Favorite extends ChangeNotifier {
  List _favoriteList = [];

  UnmodifiableListView get favoriteProducts {
    return UnmodifiableListView(_favoriteList);
  }

  void setFavoriteProducts(products) {
    _favoriteList = products;
    notifyListeners();
  }

  void addFavorite(int id) {
    _favoriteList.add(id);
    notifyListeners();
  }

  void removeFavorite(int id) {
    _favoriteList.remove(id);
    notifyListeners();
  }

  void toggleFavorite(int id) {
    _favoriteList.contains(id) ? removeFavorite(id) : addFavorite(id);
  }

  int get favoriteCount {
    return _favoriteList.length;
  }
}
