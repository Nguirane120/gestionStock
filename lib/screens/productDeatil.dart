import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';
import 'package:gestionstock/screens/productForm.dart';

class Productdeatil extends StatelessWidget {
  const Productdeatil({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail produit"),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Hero(
              tag: "product-${product.id}",
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(product.name),
          Text(product.category),
          Text(product.description),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return Text(product.quantity.toString());
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(DecreaseQuantityEvent(product.id));
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(DeleteProductEvent(product.id));
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductFormScreen(product: product,);
                }));
              },
              child: const Text("Modfier"))
        ],
      ),
    );
  }
}
