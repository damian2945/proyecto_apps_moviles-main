import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Map<String, String>? currentUser;
  const FavoritesScreen({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('❤️ Mis Favoritos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 120, color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    const Text('No tiene favoritos guardados',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    const Text(
                      'Cuando encuentre un producto que le guste,\ntoque el corazón ❤️ para guardarlo aquí.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.grey, height: 1.5),
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
              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                color: Colors.red.shade50,
                child: Row(children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Tiene ${favorites.length} producto${favorites.length == 1 ? "" : "s"} guardado${favorites.length == 1 ? "" : "s"}',
                    style: TextStyle(fontSize: 16, color: Colors.red.shade700, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) =>
                      _buildFavoriteItem(context, favorites[index], favoritesProvider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, dynamic product, FavoritesProvider favoritesProvider) {
    return GestureDetector(
      onTap: () {
        if (currentUser != null) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: product, currentUser: currentUser!)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
            child: SizedBox(
              width: 110, height: 110,
              child: Image.network(
                product.imagen, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nombre,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('\$${product.precio.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 10),
                  Row(children: [
                    // Quitar favorito
                    GestureDetector(
                      onTap: () {
                        favoritesProvider.toggleFavorite(product);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${product.nombre} quitado de favoritos'),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 2),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: const Icon(Icons.favorite, color: Colors.red, size: 22),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Agregar al carrito
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                cart.addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('✅ ${product.nombre} agregado al carrito'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Agregar',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ),
        ]),
      ),
    );
  }
}