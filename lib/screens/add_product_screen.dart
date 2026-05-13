import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Item'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('SAVE', style: TextStyle(color: Colors.green))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Add Photos Section ---
            const Text('Add Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: Colors.grey),
                  Text('Add Photos', style: TextStyle(color: Colors.grey)),
                ],
              )),
            ),
            const SizedBox(height: 20),

            // --- Product Details Form ---
            const TextField(
              decoration: InputDecoration(labelText: 'Product Name', hintText: 'What are you selling?'),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(labelText: 'Description', hintText: 'Describe the item in detail, including condition, features, and any flaws.'),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(labelText: 'Price', prefixText: '\$'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            // Dropdown para Categoría (simulado)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              initialValue: null,
              items: const [
                DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                DropdownMenuItem(value: 'Jewelery', child: Text('Jewelery')),
                // ... otras categorías
              ],
              onChanged: (String? newValue) {},
            ),
            const SizedBox(height: 30),

            // --- Submit Button ---
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Item', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}