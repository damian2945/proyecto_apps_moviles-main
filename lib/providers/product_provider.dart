import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  // Agregar productos
  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  // Buscar productos por nombre
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return _products;
    }

    final String lowerQuery = query.toLowerCase();
    return _products.where((product) {
      // Buscar solo por nombre ya que son los campos que tienes
      return product.nombre.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Obtener producto por ID
  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Agregar un producto
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // Actualizar un producto
  void updateProduct(int id, Product updatedProduct) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  // Eliminar un producto
  void deleteProduct(int id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Limpiar todos los productos
  void clearProducts() {
    _products.clear();
    notifyListeners();
  }
}