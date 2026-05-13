import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  // Agregar producto al carrito
  void addItem(Product product) {
    // Verificar si el producto ya está en el carrito
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Si ya existe, aumentar la cantidad
      _items[existingIndex].quantity++;
    } else {
      // Si no existe, agregarlo
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  // Remover producto del carrito
  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Actualizar cantidad
  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  // Limpiar carrito
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Verificar si un producto está en el carrito
  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Obtener cantidad de un producto específico
  int getProductQuantity(int productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(id: 0, nombre: '', precio: 0, imagen: ''), quantity: 0),
    );
    return item.quantity;
  }
}