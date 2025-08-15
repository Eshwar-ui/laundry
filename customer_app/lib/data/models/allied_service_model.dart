// data/models/allied_service_model.dart
class AlliedServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final double? offerPrice;
  final String category;
  final String unit;
  final bool isActive;
  final bool hasPrice;
  final DateTime updatedAt;
  final String? imageUrl;
  final int sortOrder;
  final String? iconName;

  AlliedServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.offerPrice,
    required this.category,
    required this.unit,
    required this.isActive,
    required this.hasPrice,
    required this.updatedAt,
    this.imageUrl,
    this.sortOrder = 0,
    this.iconName,
  });

  // Create AlliedServiceModel from Firestore document
  factory AlliedServiceModel.fromMap(String id, Map<String, dynamic> map) {
    return AlliedServiceModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      originalPrice: map['originalPrice'] != null ? (map['originalPrice'] as num).toDouble() : null,
      offerPrice: map['offerPrice'] != null ? (map['offerPrice'] as num).toDouble() : null,
      category: map['category'] ?? 'Allied Services',
      unit: map['unit'] ?? 'piece',
      isActive: map['isActive'] ?? true,
      hasPrice: map['hasPrice'] ?? true,
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
      imageUrl: map['imageUrl'],
      sortOrder: map['sortOrder'] ?? 0,
      iconName: map['iconName'],
    );
  }

  // Convert AlliedServiceModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      if (originalPrice != null) 'originalPrice': originalPrice,
      if (offerPrice != null) 'offerPrice': offerPrice,
      'category': category,
      'unit': unit,
      'isActive': isActive,
      'hasPrice': hasPrice,
      'updatedAt': updatedAt,
      'sortOrder': sortOrder,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (iconName != null) 'iconName': iconName,
    };
  }

  // Get effective price (offer price if available, otherwise regular price)
  double get effectivePrice {
    return offerPrice ?? price;
  }

  // Check if service has offer
  bool get hasOffer {
    return offerPrice != null && offerPrice! < price;
  }

  // Get discount percentage
  double get discountPercentage {
    if (!hasOffer) return 0;
    return ((price - effectivePrice) / price) * 100;
  }

  @override
  String toString() {
    return 'AlliedServiceModel{id: $id, name: $name, description: $description, price: $price, category: $category, unit: $unit, isActive: $isActive, hasPrice: $hasPrice}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlliedServiceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}