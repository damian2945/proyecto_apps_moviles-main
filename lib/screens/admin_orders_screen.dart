import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/purchases_provider.dart';
import '../models/purchase.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _selectedFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Pedidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Consumer<PurchasesProvider>(
        builder: (context, purchasesProvider, child) {
          final allPurchases = purchasesProvider.allPurchases;
          
          // Filtrar pedidos según el estado seleccionado
          final filteredPurchases = _selectedFilter == 'Todos'
              ? allPurchases
              : purchasesProvider.getPurchasesByStatus(_selectedFilter);

          return Column(
            children: [
              // Estadísticas superiores
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.orange.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.shopping_bag,
                        title: 'Total Pedidos',
                        value: '${allPurchases.length}',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.attach_money,
                        title: 'Total Ventas',
                        value: '\$${purchasesProvider.totalAmount.toStringAsFixed(2)}',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Filtros por estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', allPurchases.length),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Procesando',
                        purchasesProvider.getPurchasesByStatus('Procesando').length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Enviado',
                        purchasesProvider.getPurchasesByStatus('Enviado').length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Entregado',
                        purchasesProvider.getPurchasesByStatus('Entregado').length,
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),

              // Lista de pedidos
              Expanded(
                child: filteredPurchases.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFilter == 'Todos'
                                  ? 'No hay pedidos registrados'
                                  : 'No hay pedidos con estado "$_selectedFilter"',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Los pedidos aparecerán aquí cuando los clientes realicen compras',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredPurchases.length,
                        itemBuilder: (context, index) {
                          final purchase = filteredPurchases[index];
                          return _buildOrderCard(context, purchase, purchasesProvider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: Colors.orange.shade100,
      checkmarkColor: Colors.orange,
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange.shade900 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Purchase purchase,
    PurchasesProvider provider,
  ) {
    Color statusColor;
    IconData statusIcon;

    switch (purchase.estado) {
      case 'Procesando':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'Enviado':
        statusColor = Colors.blue;
        statusIcon = Icons.local_shipping;
        break;
      case 'Entregado':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(context, purchase, provider),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del pedido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${purchase.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          purchase.clienteNombre ?? 'Cliente',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          purchase.estado,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Información del pedido
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      purchase.clienteEmail ?? 'Sin email',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${purchase.fecha.day}/${purchase.fecha.month}/${purchase.fecha.year} ${purchase.fecha.hour}:${purchase.fecha.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${purchase.items.length} producto(s)',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Total y botón de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${purchase.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showOrderDetails(context, purchase, provider),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver detalles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(
    BuildContext context,
    Purchase purchase,
    PurchasesProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${purchase.id}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Contenido
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Información del cliente
                      _buildDetailSection(
                        title: 'Información del Cliente',
                        children: [
                          _buildDetailRow(Icons.person, 'Nombre', purchase.clienteNombre ?? 'N/A'),
                          _buildDetailRow(Icons.email, 'Email', purchase.clienteEmail ?? 'N/A'),
                          _buildDetailRow(
                            Icons.calendar_today,
                            'Fecha',
                            '${purchase.fecha.day}/${purchase.fecha.month}/${purchase.fecha.year} ${purchase.fecha.hour}:${purchase.fecha.minute.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Productos
                      _buildDetailSection(
                        title: 'Productos (${purchase.items.length})',
                        children: purchase.items.map((item) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imagen,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                              title: Text(item.nombre),
                              subtitle: Text('Cantidad: ${item.cantidad}'),
                              trailing: Text(
                                '\$${(item.precio * item.cantidad).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Total
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total del Pedido:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${purchase.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Cambiar estado
                      const Text(
                        'Cambiar Estado del Pedido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildStatusButton(
                            context,
                            'Procesando',
                            Colors.orange,
                            Icons.hourglass_empty,
                            purchase,
                            provider,
                          ),
                          _buildStatusButton(
                            context,
                            'Enviado',
                            Colors.blue,
                            Icons.local_shipping,
                            purchase,
                            provider,
                          ),
                          _buildStatusButton(
                            context,
                            'Entregado',
                            Colors.green,
                            Icons.check_circle,
                            purchase,
                            provider,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String status,
    Color color,
    IconData icon,
    Purchase purchase,
    PurchasesProvider provider,
  ) {
    final isCurrentStatus = purchase.estado == status;
    return ElevatedButton.icon(
      onPressed: isCurrentStatus
          ? null
          : () {
              provider.updatePurchaseStatus(purchase.id, status);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Estado actualizado a: $status'),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
      icon: Icon(icon, size: 18),
      label: Text(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: isCurrentStatus ? Colors.grey : color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[600],
      ),
    );
  }
}