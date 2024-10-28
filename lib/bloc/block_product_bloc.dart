// product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';
import 'package:gestionstock/repository/productRepository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<AddProductEvent>(_onAddProduct);
    on<FetchProductsEvent>(_onFetchProducts);
    on<DecreaseQuantityEvent>(_onDecreaseQuantity);
    on<IncreaseQuantityEvent>(_onIncreaseQuantity);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<EditProductEvent>(_onEditProduct);
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
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductQuantityUpdating(event.productId));

      try {
        final product = await productRepository.getProductById(event.productId);
        final updatedQuantity = product.quantity + 1;
        await productRepository.updateProductQuantity(
            event.productId, updatedQuantity);

        final updatedProducts = currentState.products.map((p) {
          if (p.id == event.productId) {
            return Product(
              id: p.id,
              name: p.name,
              category: p.category,
              description: p.description,
              quantity: updatedQuantity,
              imageUrl: p.imageUrl,
            );
          }
          return p;
        }).toList();

        emit(ProductLoaded(updatedProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
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

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading());

      try {
        await productRepository.deleteProduct(event.productId);

        final updatedProducts = currentState.products
            .where((product) => product.id != event.productId)
            .toList();

        emit(ProductLoaded(updatedProducts));
      } catch (e) {
        emit(ProductError("Failed to delete product: ${e.toString()}"));
      }
    }
  }

  Future<void> _onEditProduct(
      EditProductEvent event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading()); // Affiche l'état de chargement

      try {
        await productRepository.updateProduct(
          productId: event.productId,
          name: event.name,
          category: event.category,
          description: event.description,
          quantity: event.quantity,
          imageUrl: event.imageUrl,
        );

        // Mettre à jour la liste des produits avec le produit modifié
        final updatedProducts = currentState.products.map((product) {
          if (product.id == event.productId) {
            return Product(
              id: event.productId,
              name: event.name,
              category: event.category,
              description: event.description,
              quantity: event.quantity,
              imageUrl: event.imageUrl,
            );
          }
          return product;
        }).toList();

        emit(ProductLoaded(
            updatedProducts)); // Émettre l'état avec la liste mise à jour
      } catch (e) {
        emit(ProductError("Failed to edit product: ${e.toString()}"));
      }
    }
  }
}
