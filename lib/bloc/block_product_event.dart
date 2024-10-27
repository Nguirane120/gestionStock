// product_event.dart
import 'dart:io';

abstract class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String name;
  final String category;
  final String description;
  final int quantity;
  final String user;
  final File imageFile;

  AddProductEvent(this.name, this.category, this.description, this.quantity, this.imageFile, this.user);
}

class FetchProductsEvent extends ProductEvent {}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent(this.productId);
}
class IncreaseQuantityEvent extends ProductEvent {
  final String productId; 
  IncreaseQuantityEvent(this.productId);
}

class DecreaseQuantityEvent extends ProductEvent {
  final String productId; 
  DecreaseQuantityEvent(this.productId);
}