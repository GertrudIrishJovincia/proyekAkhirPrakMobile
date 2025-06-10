import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  void addFavorite(Map<String, dynamic> product) {
    if (!_favorites.any((item) => item['id'] == product['id'])) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(int productId) {
    _favorites.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item['id'] == productId);
  }
}
