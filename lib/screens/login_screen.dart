import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'admin_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final Map<String, Map<String, String>> _localUsers = {
    'admin': {
      'password': 'admin123',
      'nombre': 'Administrador',
      'telefono': '+52 312 000 0000',
      'direccion': 'Tienda Principal',
      'role': 'admin',
    },
    'damian@gmail.com': {
      'password': '1234',
      'nombre': 'Damian',
      'telefono': '+52 312 456 7890',
      'direccion': 'Colima, México',
      'role': 'customer',
    },
    'alberto@gmail.com': {
      'password': '123456',
      'nombre': 'Alberto',
      'telefono': '+52 312 123 4567',
      'direccion': 'Guadalajara, México',
      'role': 'customer',
    },
    'jesus@gmail.com': {
      'password': '123456789',
      'nombre': 'Jesús',
      'telefono': '+52 312 987 6543',
      'direccion': 'Monterrey, México',
      'role': 'customer',
    },
  };

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      Future.delayed(const Duration(seconds: 1), () {
        if (_localUsers.containsKey(email) &&
            _localUsers[email]!['password'] == password) {
          if (!mounted) return;
          final userData = {
            'email': email,
            'nombre': _localUsers[email]!['nombre']!,
            'telefono': _localUsers[email]!['telefono']!,
            'direccion': _localUsers[email]!['direccion']!,
            'role': _localUsers[email]!['role']!,
          };
          if (userData['role'] == 'admin') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminNavigation(currentUser: userData)));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainNavigation(currentUser: userData)));
          }
        } else {
          if (!mounted) return;
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(children: [
                Icon(Icons.error_outline, color: Colors.red, size: 36),
                SizedBox(width: 12),
                Expanded(child: Text('Datos incorrectos', style: TextStyle(fontSize: 22))),
              ]),
              content: const Text(
                'El usuario o la contraseña no son correctos.\n\nPor favor revise lo que escribió e intente de nuevo.',
                style: TextStyle(fontSize: 18, height: 1.5),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white, size: 24),
                    label: const Text('Entendido, intentar de nuevo',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícono tienda
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.shopping_bag, size: 72, color: Colors.blue),
                      ),
                      const SizedBox(height: 20),
                      const Text('Bienvenido a la Tienda',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 10),
                      const Text(
                        'Escriba sus datos para entrar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // Paso 1
                      _buildStepLabel('Paso 1 de 2', 'Escriba su usuario o correo electrónico:'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                          hintText: 'Ejemplo: correo@gmail.com',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          prefixIcon: const Icon(Icons.person, size: 30, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Colors.blue, width: 2.5)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '⚠️ Por favor escriba su usuario o correo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Paso 2
                      _buildStepLabel('Paso 2 de 2', 'Escriba su contraseña:'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                          hintText: 'Escriba su contraseña aquí',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock, size: 30, color: Colors.blue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              size: 28, color: Colors.grey,
                            ),
                            tooltip: _obscurePassword ? 'Mostrar contraseña' : 'Ocultar contraseña',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Colors.blue, width: 2.5)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '⚠️ Por favor escriba su contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Botón entrar
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 4,
                          ),
                          icon: _isLoading
                              ? const SizedBox(width: 26, height: 26,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                              : const Icon(Icons.login, size: 30),
                          label: Text(
                            _isLoading ? 'Entrando a la tienda...' : 'ENTRAR A LA TIENDA',
                            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ayuda
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Row(children: [
                                Icon(Icons.help, color: Colors.blue, size: 30),
                                SizedBox(width: 10),
                                Text('¿Necesita ayuda?', style: TextStyle(fontSize: 22)),
                              ]),
                              content: const Text(
                                'Si olvidó su contraseña, comuníquese con el administrador de la tienda para que le ayude a recuperar su acceso.',
                                style: TextStyle(fontSize: 17, height: 1.6),
                              ),
                              actions: [
                                SizedBox(
                                  width: double.infinity, height: 54,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    child: const Text('Entendido', style: TextStyle(fontSize: 18, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        ),
                        icon: const Icon(Icons.help_outline, size: 24, color: Colors.blue),
                        label: const Text('¿Olvidó su contraseña?',
                            style: TextStyle(fontSize: 17, color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepLabel(String step, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(step, style: const TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}