import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  int get favoritesCount => _favorites.length;

  // Agregar o remover de favoritos
  void toggleFavorite(Product product) {
    final index = _favorites.indexWhere((item) => item.id == product.id);
    
    if (index >= 0) {
      // Si ya existe, removerlo
      _favorites.removeAt(index);
    } else {
      // Si no existe, agregarlo
      _favorites.add(product);
    }
    notifyListeners();
  }

  // Verificar si un producto está en favoritos
  bool isFavorite(int productId) {
    return _favorites.any((item) => item.id == productId);
  }

  // Limpiar favoritos
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  // Remover de favoritos
  void removeFavorite(int productId) {
    _favorites.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}