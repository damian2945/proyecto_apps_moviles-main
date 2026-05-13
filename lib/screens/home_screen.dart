import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/custom_search_delegate.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, String> currentUser;
  const HomeScreen({super.key, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      final products = await _apiService.fetchAllProducts();
      setState(() { _products = products; _isLoading = false; });
    } catch (e) {
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🛍️ Tienda en Línea',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Hola, ${widget.currentUser['nombre'] ?? 'Cliente'} 👋',
                style: const TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 32),
            tooltip: 'Buscar un producto',
            onPressed: () => showSearch(
                context: context, delegate: CustomSearchDelegate(_products)),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            tooltip: 'Actualizar productos',
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircularProgressIndicator(strokeWidth: 4),
                SizedBox(height: 20),
                Text('Cargando productos, por favor espere...',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ]),
            )
          : _errorMessage.isNotEmpty
              ? _buildError()
              : _buildProductList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 90, color: Colors.red),
            const SizedBox(height: 20),
            const Text('No se pudieron cargar los productos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Verifique que tiene internet\ne intente de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60, width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loadProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.refresh, size: 30, color: Colors.white),
                label: const Text('Intentar de nuevo',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: CustomScrollView(
        slivers: [
          // Banner de ayuda
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.blue, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Toque cualquier producto para ver más información y comprarlo',
                      style: TextStyle(fontSize: 16, color: Colors.blue, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de productos (una sola columna, tarjetas grandes)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(_products[index]),
              childCount: _products.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductDetailScreen(product: product, currentUser: widget.currentUser),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
              child: SizedBox(
                width: 130,
                height: 130,
                child: Image.network(
                  product.imagen,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text('\$${product.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Favorito
                        Consumer<FavoritesProvider>(
                          builder: (context, favorites, child) {
                            final isFav = favorites.isFavorite(product.id);
                            return GestureDetector(
                              onTap: () {
                                favorites.toggleFavorite(product);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(isFav
                                      ? '${product.nombre} quitado de favoritos'
                                      : '${product.nombre} guardado en favoritos'),
                                  backgroundColor: isFav ? Colors.orange : Colors.green,
                                  duration: const Duration(seconds: 2),
                                ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isFav ? Colors.red.shade50 : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: isFav ? Colors.red.shade200 : Colors.grey.shade300),
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            );
                          },
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Flecha indicadora
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}