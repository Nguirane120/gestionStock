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

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value.toLowerCase(); 
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  
                  final filteredProducts = state.products.where((product) {
                    return product.name.toLowerCase().contains(_searchTerm) ||
                           product.category.toLowerCase().contains(_searchTerm);
                  }).toList();
            
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
