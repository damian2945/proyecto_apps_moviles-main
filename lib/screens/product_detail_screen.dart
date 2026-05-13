import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/purchases_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/purchase.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Map<String, String> currentUser;
  const ProductDetailScreen({super.key, required this.product, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Detalle del producto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final isFav = favorites.isFavorite(product.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white, size: 30),
                tooltip: isFav ? 'Quitar de favoritos' : 'Guardar en favoritos',
                onPressed: () {
                  favorites.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isFav
                        ? '${product.nombre} quitado de favoritos'
                        : '${product.nombre} guardado en favoritos'),
                    backgroundColor: isFav ? Colors.orange : Colors.green,
                  ));
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen grande
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              child: Image.network(
                product.imagen,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre grande
                  Text(product.nombre,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 16),

                  // Precio muy visible
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade300, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sell, color: Colors.green, size: 32),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Precio del producto:',
                                style: TextStyle(fontSize: 15, color: Colors.grey)),
                            Text('\$${product.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info del producto
                  const Text('¿Qué incluye este producto?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _infoTile(Icons.check_circle, 'Disponible', 'En stock, listo para enviar', Colors.green),
                  _infoTile(Icons.local_shipping, 'Envío gratis', 'Lo llevamos a su domicilio sin costo', Colors.blue),
                  _infoTile(Icons.verified_user, 'Garantía', '12 meses de garantía incluida', Colors.orange),
                  _infoTile(Icons.swap_horiz, 'Devoluciones', 'Puede devolver el producto en 30 días', Colors.purple),
                  const SizedBox(height: 20),

                  // Instrucción clara
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade200, width: 1.5),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 26),
                          SizedBox(width: 8),
                          Text('¿Cómo comprar?',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ]),
                        SizedBox(height: 8),
                        Text('• Toque "AGREGAR AL CARRITO" para seguir comprando más productos.',
                            style: TextStyle(fontSize: 15, color: Colors.blue, height: 1.5)),
                        SizedBox(height: 4),
                        Text('• Toque "COMPRAR AHORA" para comprar solo este producto de inmediato.',
                            style: TextStyle(fontSize: 15, color: Colors.blue, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              final isInCart = cart.isInCart(product.id);
              final quantity = cart.getProductQuantity(product.id);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInCart) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Ya tiene $quantity ${quantity == 1 ? "unidad" : "unidades"} en su carrito',
                          style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ]),
                    ),
                  ],
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cart.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Row(children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text('¡Producto agregado al carrito!', style: TextStyle(fontSize: 16)),
                              ]),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.shopping_cart, size: 26),
                          label: const Text('AGREGAR\nAL CARRITO',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton.icon(
                          onPressed: () => _showBuyDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.shopping_bag, size: 26),
                          label: const Text('COMPRAR\nAHORA',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ]),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.shopping_bag, color: Colors.green, size: 32),
          SizedBox(width: 10),
          Expanded(child: Text('¿Confirmar compra?', style: TextStyle(fontSize: 22))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Usted está a punto de comprar:',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(product.nombre,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.sell, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total a pagar:', style: TextStyle(fontSize: 15, color: Colors.grey)),
                  Text('\$${product.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green)),
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
                    total: product.precio,
                    items: [PurchaseItem(
                      productId: product.id.toString(),
                      nombre: product.nombre,
                      precio: product.precio,
                      cantidad: 1,
                      imagen: product.imagen,
                    )],
                    estado: 'Procesando',
                    clienteEmail: currentUser['email'] ?? 'cliente@ejemplo.com',
                    clienteNombre: currentUser['nombre'] ?? 'Cliente',
                  ));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('✅ ¡Compra realizada con éxito!',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('Número de pedido: #$purchaseId'),
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
                label: const Text('SÍ, QUIERO COMPRARLO',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                icon: const Icon(Icons.arrow_back, size: 24, color: Colors.grey),
                label: const Text('No, regresar',
                    style: TextStyle(fontSize: 17, color: Colors.grey)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }
}