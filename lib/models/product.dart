class Product {
  final String id;
  final String productName;
  final int productPrice;
  final String productDescription;
  final bool isFavorite;
  final String productImage;
  final String outlet;
  final String category;
  final double rating;
  final int ratingTotals;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.isFavorite,
    required this.productImage,
    required this.outlet,
    required this.category,
    required this.rating,
    required this.ratingTotals,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      productName: json['product_name'] ?? 'Tanpa Nama',
      productPrice: json['product_price'] ?? 0,
      productDescription: json['product_description'] ?? '-',
      isFavorite: json['is_favorite'] ?? false,
      productImage: json['product_image'] ?? '',
      outlet: json['outlet'] ?? '-',
      category: json['category'] ?? '-',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : double.tryParse(json['rating'].toString()) ?? 0.0,
      ratingTotals: json['rating_totals'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
