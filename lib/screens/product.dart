import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';
import 'package:gestionstock/repository/productRepository.dart';
import 'package:gestionstock/widgets/productcard.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Déclenche l'événement de récupération des produits
    context.read<ProductBloc>().add(FetchProductsEvent());

    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(product: product);
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text("Erreur : ${state.error}"));
          } else {
            return Center(child: Text("Aucun produit trouvé"));
          }
        },
      ),
    );
  }
}

