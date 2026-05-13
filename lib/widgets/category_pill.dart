import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  final String name;
  final IconData icon;
  final String categoryFilter;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.name,
    required this.icon,
    required this.categoryFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 30),
            ),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// Nota: Para usarlo, deberías actualizar HomeContent en home_screen.dart
/*
SizedBox(
  height: 120,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      CategoryPill(
        name: 'Jewelery',
        icon: Icons.diamond,
        categoryFilter: 'jewelery',
        onTap: () {
          // Lógica de navegación
        }
      ),
      // ... más píldoras
    ],
  ),
),
*/