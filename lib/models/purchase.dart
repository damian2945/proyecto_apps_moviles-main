class PurchaseItem {
  final String productId;
  final String nombre;
  final double precio;
  final int cantidad;
  final String imagen;

  PurchaseItem({
    required this.productId,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.imagen,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'imagen': imagen,
    };
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      productId: json['productId'],
      nombre: json['nombre'],
      precio: json['precio'].toDouble(),
      cantidad: json['cantidad'],
      imagen: json['imagen'],
    );
  }
}

class Purchase {
  final String id;
  final DateTime fecha;
  final double total;
  final List<PurchaseItem> items;
  String estado; // Procesando, Enviado, Entregado
  final String? clienteEmail; // Email del cliente que hizo la compra
  final String? clienteNombre; // Nombre del cliente

  Purchase({
    required this.id,
    required this.fecha,
    required this.total,
    required this.items,
    this.estado = 'Procesando',
    this.clienteEmail,
    this.clienteNombre,
  });

  // Método para cambiar el estado
  void updateEstado(String nuevoEstado) {
    estado = nuevoEstado;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
      'estado': estado,
      'clienteEmail': clienteEmail,
      'clienteNombre': clienteNombre,
    };
  }

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      total: json['total'].toDouble(),
      items: (json['items'] as List)
          .map((item) => PurchaseItem.fromJson(item))
          .toList(),
      estado: json['estado'] ?? 'Procesando',
      clienteEmail: json['clienteEmail'],
      clienteNombre: json['clienteNombre'],
    );
  }
}