import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/purchases_provider.dart';
import 'package:intl/intl.dart';

class PurchasesScreen extends StatelessWidget {
  final Map<String, String>? currentUser;
  const PurchasesScreen({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('🛍️ Mis Compras',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<PurchasesProvider>(
        builder: (context, purchasesProvider, child) {
          final purchases = currentUser != null
              ? purchasesProvider.getPurchasesByEmail(currentUser!['email']!)
              : purchasesProvider.purchases;

          if (purchases.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 120, color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    const Text('Aún no ha realizado compras',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    const Text(
                      'Cuando compre algo, aquí podrá ver el estado\nde todos sus pedidos.',
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
                color: Colors.blue.shade50,
                child: Row(children: [
                  const Icon(Icons.shopping_bag, color: Colors.blue, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Tiene ${purchases.length} ${purchases.length == 1 ? "compra realizada" : "compras realizadas"}',
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade800, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: purchases.length,
                  itemBuilder: (context, index) => _buildPurchaseCard(context, purchases[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPurchaseCard(BuildContext context, dynamic purchase) {
    final dateFormat = DateFormat("dd 'de' MMMM 'de' yyyy, HH:mm", 'es_MX');
    final Color statusColor = _getStatusColor(purchase.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          // Header estado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(_getStatusIcon(purchase.estado), color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pedido #${purchase.id}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    (() {
                      try { return dateFormat.format(purchase.fecha); }
                      catch (_) { return DateFormat('dd/MM/yyyy HH:mm').format(purchase.fecha); }
                    })(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                child: Text(purchase.estado,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),

          // Descripción del estado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: statusColor.withOpacity(0.05),
            child: Row(children: [
              Icon(Icons.info_outline, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_getStatusDescription(purchase.estado),
                    style: TextStyle(fontSize: 14, color: statusColor, fontWeight: FontWeight.w500)),
              ),
            ]),
          ),

          // Productos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Productos comprados:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...purchase.items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imagen, width: 65, height: 65, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 65, height: 65, color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.nombre,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Cantidad: ${item.cantidad}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ]),
                    ),
                    Text('\$${(item.precio * item.cantidad).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  ]),
                )),
                const Divider(thickness: 1.5),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total pagado:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$${purchase.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'Procesando': return Colors.orange;
      case 'Enviado': return Colors.blue;
      case 'Entregado': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String estado) {
    switch (estado) {
      case 'Procesando': return Icons.hourglass_empty;
      case 'Enviado': return Icons.local_shipping;
      case 'Entregado': return Icons.check_circle;
      default: return Icons.help_outline;
    }
  }

  String _getStatusDescription(String estado) {
    switch (estado) {
      case 'Procesando': return 'Su pedido está siendo preparado. En breve lo enviaremos.';
      case 'Enviado': return 'Su pedido ya va en camino. Llegará pronto a su domicilio.';
      case 'Entregado': return '¡Su pedido fue entregado exitosamente! Gracias por su compra.';
      default: return 'Estado desconocido.';
    }
  }
}