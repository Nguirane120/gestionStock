class Product {
  String id;
  String name;
  String category;
  String description;
  String imageUrl;
  int quantity;
  String? userEmail;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.imageUrl,
      required this.quantity,
       this.userEmail});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'userEmail': userEmail
    };
  }

  static Product fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 0,
      userEmail: map['userEmail'] ?? '',
    );
  }
}
