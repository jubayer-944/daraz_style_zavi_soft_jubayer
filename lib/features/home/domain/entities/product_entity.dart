class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
    this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String image;
  final RatingEntity? rating;
}

class RatingEntity {
  const RatingEntity({
    required this.rate,
    required this.count,
  });

  final double rate;
  final int count;
}

