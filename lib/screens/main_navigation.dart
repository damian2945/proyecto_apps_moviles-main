import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../providers/cart_provider.dart';

class MainNavigation extends StatefulWidget {
  final Map<String, String> currentUser;
  const MainNavigation({super.key, required this.currentUser});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(currentUser: widget.currentUser),
      CartScreen(currentUser: widget.currentUser),
      ProfileScreen(currentUser: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, -3)),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              // Letras más grandes para adultos mayores
              selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              iconSize: 30,
              items: [
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home),
                  ),
                  label: 'Inicio',
                  tooltip: 'Ir a la tienda',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Badge(
                      label: Text('${cart.itemCount}', style: const TextStyle(fontSize: 12)),
                      isLabelVisible: cart.itemCount > 0,
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Badge(
                      label: Text('${cart.itemCount}', style: const TextStyle(fontSize: 12)),
                      isLabelVisible: cart.itemCount > 0,
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                  label: 'Mi Carrito',
                  tooltip: 'Ver mi carrito',
                ),
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person),
                  ),
                  label: 'Mi Perfil',
                  tooltip: 'Ver mi perfil',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}