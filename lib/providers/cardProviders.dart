import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  void addItem(Map<String, dynamic> product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += (item["productPrice"] ?? 0) as int;
    }
    return total;
  }
}
