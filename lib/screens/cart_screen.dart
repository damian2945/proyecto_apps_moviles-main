import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/purchases_provider.dart';
import '../models/purchase.dart';

class CartScreen extends StatelessWidget {
  final Map<String, String>? currentUser;
  const CartScreen({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('🛒 Mi Carrito de Compras',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) return const SizedBox();
              return TextButton.icon(
                onPressed: () => _showClearCartDialog(context, cart),
                icon: const Icon(Icons.delete_sweep, color: Colors.white, size: 26),
                label: const Text('Vaciar todo', style: TextStyle(color: Colors.white, fontSize: 15)),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    const Text('Su carrito está vacío',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    const Text(
                      'Todavía no ha agregado ningún producto.\nRegrese a la tienda y elija lo que desea comprar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 60, width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.store, color: Colors.white, size: 28),
                        label: const Text('IR A LA TIENDA',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Banner resumen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                color: Colors.blue.shade50,
                child: Row(children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Tiene ${cart.items.length} ${cart.items.length == 1 ? "producto" : "productos"} en su carrito',
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade800, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) =>
                      _buildCartItem(context, cart.items[index], cart),
                ),
              ),
              _buildSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.product.imagen,
                  width: 100, height: 100, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100, height: 100, color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.product.nombre,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('Precio unitario: \$${item.product.precio.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Cantidad con botones grandes
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Cantidad:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(children: [
                  _qtyBtn(
                    icon: Icons.remove,
                    color: Colors.orange,
                    label: 'Menos',
                    onTap: () => cart.updateQuantity(item.product.id, item.quantity - 1),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('${item.quantity}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  _qtyBtn(
                    icon: Icons.add,
                    color: Colors.green,
                    label: 'Más',
                    onTap: () => cart.updateQuantity(item.product.id, item.quantity + 1),
                  ),
                ]),
              ]),
              // Botón eliminar con texto
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    cart.removeItem(item.product.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${item.product.nombre} eliminado del carrito'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  label: const Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Row(children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total a pagar:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green)),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity, height: 64,
            child: ElevatedButton.icon(
              onPressed: () => _showConfirmDialog(context, cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              icon: const Icon(Icons.payment, size: 30),
              label: const Text('PROCEDER AL PAGO',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.warning_amber, color: Colors.orange, size: 32),
          SizedBox(width: 10),
          Expanded(child: Text('¿Vaciar el carrito?', style: TextStyle(fontSize: 22))),
        ]),
        content: const Text(
          '¿Está seguro que desea eliminar TODOS los productos de su carrito?\n\nEsta acción no se puede deshacer.',
          style: TextStyle(fontSize: 17, height: 1.5),
        ),
        actions: [
          Column(children: [
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  cart.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Carrito vaciado correctamente', style: TextStyle(fontSize: 16)),
                    backgroundColor: Colors.orange,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete_sweep, color: Colors.white, size: 26),
                label: const Text('Sí, eliminar todo',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity, height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 24),
                label: const Text('No, regresar', style: TextStyle(fontSize: 17, color: Colors.grey)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.payment, color: Colors.green, size: 32),
          SizedBox(width: 10),
          Expanded(child: Text('¿Confirmar su pago?', style: TextStyle(fontSize: 22))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cantidad de productos: ${cart.itemCount}',
                style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.sell, color: Colors.green, size: 30),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total que va a pagar:', style: TextStyle(fontSize: 15, color: Colors.grey)),
                  Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green)),
                ]),
              ]),
            ),
          ],
        ),
        actions: [
          Column(children: [
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final purchasesProvider = Provider.of<PurchasesProvider>(context, listen: false);
                  final purchaseId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
                  purchasesProvider.addPurchase(Purchase(
                    id: purchaseId,
                    fecha: DateTime.now(),
                    total: cart.totalAmount,
                    items: cart.items.map((cartItem) => PurchaseItem(
                      productId: cartItem.product.id.toString(),
                      nombre: cartItem.product.nombre,
                      precio: cartItem.product.precio,
                      cantidad: cartItem.quantity,
                      imagen: cartItem.product.imagen,
                    )).toList(),
                    estado: 'Procesando',
                    clienteEmail: currentUser?['email'] ?? 'cliente@ejemplo.com',
                    clienteNombre: currentUser?['nombre'] ?? 'Cliente',
                  ));
                  cart.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('✅ ¡Su compra fue realizada con éxito!',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('Número de pedido: #$purchaseId', style: const TextStyle(fontSize: 14)),
                    ]),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 4),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check_circle, size: 28, color: Colors.white),
                label: const Text('SÍ, PAGAR AHORA',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity, height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 24),
                label: const Text('No, regresar', style: TextStyle(fontSize: 17, color: Colors.grey)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}