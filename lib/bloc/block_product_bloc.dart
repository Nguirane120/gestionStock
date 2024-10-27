// product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/repository/productRepository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<AddProductEvent>(_onAddProduct);
    on<FetchProductsEvent>(_onFetchProducts);
    on<DecreaseQuantityEvent>(_onDecreaseQuantity);
    on<IncreaseQuantityEvent>(_onIncreaseQuantity);
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.addProduct(
        name: event.name,
        userEmail: event.user,
        category: event.category,
        description: event.description,
        quantity: event.quantity,
        imageFile: event.imageFile,
      );
      add(FetchProductsEvent());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onIncreaseQuantity(
      IncreaseQuantityEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
     
      final product = await productRepository.getProductById(event.productId);
      await productRepository.updateProductQuantity(
          event.productId, product.quantity + 1);
      emit(ProductLoaded(await productRepository.fetchProducts()));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDecreaseQuantity(
      DecreaseQuantityEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      
      final product = await productRepository.getProductById(event.productId);
      if (product.quantity > 0) {
        await productRepository.updateProductQuantity(
            event.productId, product.quantity - 1);
      }
      emit(ProductLoaded(await productRepository.fetchProducts()));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
