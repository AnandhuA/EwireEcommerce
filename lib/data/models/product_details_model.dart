class ProductDetailsModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final int weight;
  final ProductDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final List<String> images;
  final String thumbnail;

  ProductDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.images,
    required this.thumbnail,
  });

  factory ProductDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      weight: json['weight'] ?? 0,
      dimensions: ProductDimensions.fromJson(
        json['dimensions'] ?? {},
      ),
      warrantyInformation:
          json['warrantyInformation'] ?? '',
      shippingInformation:
          json['shippingInformation'] ?? '',
      availabilityStatus:
          json['availabilityStatus'] ?? '',
      reviews: (json['reviews'] as List? ?? [])
          .map(
            (e) => ProductReview.fromJson(e),
          )
          .toList(),
      returnPolicy: json['returnPolicy'] ?? '',
      minimumOrderQuantity:
          json['minimumOrderQuantity'] ?? 0,
      images: List<String>.from(
        json['images'] ?? [],
      ),
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

class ProductDimensions {
  final double width;
  final double height;
  final double depth;

  ProductDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory ProductDimensions.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductDimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ProductReview {
  final int rating;
  final String comment;
  final String reviewerName;

  ProductReview({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  factory ProductReview.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductReview(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      reviewerName:
          json['reviewerName'] ?? '',
    );
  }
}