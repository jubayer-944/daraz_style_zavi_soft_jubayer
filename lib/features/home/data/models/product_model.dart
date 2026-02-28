import 'package:daraz_style/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.category,
    required super.description,
    required super.image,
    super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'] as Map<String, dynamic>?;
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: ratingJson == null
          ? null
          : RatingEntity(
              rate: (ratingJson['rate'] as num).toDouble(),
              count: (ratingJson['count'] as num).toInt(),
            ),
    );
  }
}

