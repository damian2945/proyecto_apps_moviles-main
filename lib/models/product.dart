class Product {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;
  final String? creadoEn;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    this.creadoEn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] is String) 
          ? double.parse(json['precio']) 
          : (json['precio'] ?? 0.0).toDouble(),
      imagen: json['imagen'] ?? '',
      creadoEn: json['creado_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'imagen': imagen,
      'creado_en': creadoEn,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'nombre': nombre,
      'precio': precio,
      'imagen': imagen,
    };
  }
}