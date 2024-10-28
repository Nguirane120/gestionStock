import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';
import 'package:gestionstock/screens/productDeatil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
            leading: product.imageUrl.isNotEmpty
                ? Hero(
                    tag: "product-${product.id}",
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                      product.imageUrl,
                    )),
                  )
                : const Icon(Icons.image),
            title: Text(product.name),
            subtitle: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Productdeatil(
                    product: product,
                  );
                }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category: ${product.category}"),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      return Text("Quantity: ${product.quantity}");
                    },
                  ),
                ],
              ),
            ),
            trailing: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                bool isUpdating = state is ProductQuantityUpdating &&
                    state.productId == product.id;
      
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(IncreaseQuantityEvent(product.id));
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                );
              },
            )),
      ),
    );
  }
}
