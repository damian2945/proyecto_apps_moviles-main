import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart'; // ← Asegúrate de que esta ruta sea correcta

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  
  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final results = productProvider.searchProducts(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultados para "$searchQuery"', 
          style: const TextStyle(color: Colors.black)
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: results.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sentiment_dissatisfied, 
                      size: 50, 
                      color: Colors.grey
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No se encontraron productos para "$searchQuery".',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Intenta ajustar los términos de búsqueda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                // ✅ CORRECCIÓN: Usar ProductCard correctamente
                return ProductCard(
                  product: results[index],
                  // Si tu ProductCard necesita más parámetros, agrégalos aquí
                );
              },
            ),
    );
  }
}