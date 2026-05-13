import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Cambiar product.price por product.precio
  double get subtotal => product.precio * quantity;
}