import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'favorites_screen.dart';
import 'purchases_screen.dart';
import 'admin_orders_screen.dart';
import '../providers/favorites_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, String> currentUser;

  const ProfileScreen({super.key, required this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Lista de todos los usuarios locales
  final Map<String, Map<String, String>> _allUsers = {
    'admin': {
      'nombre': 'Administrador',
      'telefono': '+52 312 000 0000',
      'direccion': 'Tienda Principal',
      'role': 'admin',
    },
    'damian@gmail.com': {
      'nombre': 'Damián',
      'telefono': '+52 312 456 7890',
      'direccion': 'Colima, México',
      'role': 'customer',
    },
    'alberto@gmail.com': {
      'nombre': 'Alberto',
      'telefono': '+52 312 123 4567',
      'direccion': 'Guadalajara, México',
      'role': 'customer',
    },
    'jesus@gmail.com': {
      'nombre': 'Jesús',
      'telefono': '+52 312 987 6543',
      'direccion': 'Monterrey, México',
      'role': 'customer',
    },
  };

  bool get isAdmin => widget.currentUser['role'] == 'admin';

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: Text('¿Estás seguro de cerrar sesión como ${widget.currentUser['nombre']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              // Navegar al login y eliminar todas las rutas anteriores
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color get _primaryColor => isAdmin ? Colors.orange : Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con foto de perfil y datos principales
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: isAdmin
                        ? const Icon(
                            Icons.admin_panel_settings,
                            size: 50,
                            color: Colors.orange,
                          )
                        : Text(
                            widget.currentUser['nombre']![0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.currentUser['nombre']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.currentUser['email']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          isAdmin ? 'Administrador activo' : 'Sesión activa',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.security, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Permisos de vendedor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de la cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    icon: Icons.person_outline,
                    title: 'Nombre completo',
                    value: widget.currentUser['nombre']!,
                    onTap: () {},
                  ),
                  _buildProfileItem(
                    icon: isAdmin ? Icons.admin_panel_settings_outlined : Icons.email_outlined,
                    title: isAdmin ? 'Usuario' : 'Correo electrónico',
                    value: widget.currentUser['email']!,
                    onTap: () {},
                  ),
                  _buildProfileItem(
                    icon: Icons.phone_outlined,
                    title: 'Teléfono',
                    value: widget.currentUser['telefono']!,
                    onTap: () {},
                  ),
                  _buildProfileItem(
                    icon: Icons.location_on_outlined,
                    title: isAdmin ? 'Ubicación' : 'Dirección',
                    value: widget.currentUser['direccion']!,
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // NUEVA SECCIÓN: Mis actividades (solo para compradores)
                  if (!isAdmin) ...[
                    const Text(
                      'Mis actividades',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildProfileItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Mis compras',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PurchasesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildProfileItem(
                      icon: Icons.favorite_outline,
                      title: 'Mis favoritos',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<FavoritesProvider>(
                            builder: (context, favorites, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${favorites.favoritesCount}',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Información de sesión
                  const Text(
                    'Información de sesión',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.login, color: _primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuario activo',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      widget.currentUser['email']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.badge_outlined, color: _primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tipo de cuenta',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      isAdmin ? 'Administrador (Vendedor)' : 'Cliente (Comprador)',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.people_outline, color: _primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios registrados',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      '${_allUsers.length} cuentas locales',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => _showAllUsers(context),
                                child: const Text('Ver'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sección de permisos para admin
                  if (isAdmin) ...[
                    const Text(
                      'Permisos de administrador',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildPermissionItem(
                              icon: Icons.add_circle_outline,
                              title: 'Crear productos',
                              description: 'Agregar nuevos productos al inventario',
                            ),
                            const Divider(),
                            _buildPermissionItem(
                              icon: Icons.edit_outlined,
                              title: 'Editar productos',
                              description: 'Modificar información de productos',
                            ),
                            const Divider(),
                            _buildPermissionItem(
                              icon: Icons.delete_outline,
                              title: 'Eliminar productos',
                              description: 'Remover productos del inventario',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // BOTÓN NUEVO: Gestionar Pedidos
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminOrdersScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text(
                          'Gestionar Pedidos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(title),
        subtitle: value != null ? Text(value) : null,
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 12),
      ),
      dense: true,
    );
  }

  void _showAllUsers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuarios registrados localmente'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _allUsers.length,
            itemBuilder: (context, index) {
              final email = _allUsers.keys.elementAt(index);
              final userData = _allUsers[email]!;
              final isActive = email == widget.currentUser['email'];
              final isAdminUser = userData['role'] == 'admin';
              
              return Card(
                color: isActive ? _primaryColor.withOpacity(0.1) : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive ? _primaryColor : Colors.grey,
                    child: isAdminUser
                        ? const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            userData['nombre']![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                  title: Text(
                    email,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    isActive
                        ? '${userData['nombre']} - Sesión activa'
                        : '${userData['nombre']} - ${isAdminUser ? "Administrador" : "Cliente"}',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  trailing: isActive
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}