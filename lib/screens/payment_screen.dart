import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN: Se debe llamar a Provider.of<Tipo>()
    final cart = Provider.of<CartProvider>(context);
    const double shipping = 10.00;
    final double subtotal = cart.totalAmount;
    final double grandTotal = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Order Summary ---
              const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
              _buildSummaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
              const Divider(),
              _buildSummaryRow('Total', '\$${grandTotal.toStringAsFixed(2)}', isTotal: true),
              const SizedBox(height: 30),

              // --- Select Payment Method ---
              const Text('Select Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Credit Card Form (Simplified)
              _buildPaymentMethodTile(context, 'Credit Card', Icons.credit_card),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(decoration: InputDecoration(labelText: 'Card Number', border: OutlineInputBorder())),
              ),

              // Digital Wallet (Simplified)
              _buildPaymentMethodTile(context, 'Digital Wallet', Icons.wallet),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Lógica para confirmar el pago y limpiar el carrito
            cart.clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Confirmed!')),
            );
            Navigator.of(context).popUntil((route) => route.isFirst); // Vuelve a la pantalla principal
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text('Confirm and Pay \$${grandTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(BuildContext context, String title, IconData icon) {
    // Simula un botón de selección
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
      contentPadding: EdgeInsets.zero,
    );
  }
}