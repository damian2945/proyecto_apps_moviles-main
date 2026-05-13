import 'package:flutter/material.dart';

class ReviewStarRating extends StatelessWidget {
  final double rating;
  final int count;
  final double size;

  const ReviewStarRating({
    super.key,
    required this.rating,
    this.count = 0,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    double fractionalPart = rating - fullStars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrellas completas
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.orange, size: size),
        
        // Media estrella (si aplica)
        if (fractionalPart > 0)
          Icon(
            fractionalPart < 0.5 ? Icons.star_half : Icons.star,
            color: Colors.orange,
            size: size,
          ),
        
        // Estrellas vacías para completar 5
        for (int i = 0; i < 5 - fullStars - (fractionalPart > 0 ? 1 : 0); i++)
          Icon(Icons.star_border, color: Colors.orange, size: size),
        
        // Conteo de reviews
        if (count > 0)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '($count reviews)',
              style: TextStyle(fontSize: size * 0.7, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

// Nota: Puedes usarlo en product_detail_screen.dart:
/*
// Reemplazar: Text('${product.rating.rate} stars (${product.rating.count} reviews)'),
ReviewStarRating(
  rating: product.rating.rate, 
  count: product.rating.count,
)
*/