import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';

class Productdeatil extends StatelessWidget {
  const Productdeatil({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail produit"),
      ),
      body: Column(
        children: [
          Container(
            child: Image.network(product.imageUrl),
          ),
          Text(product.name),
          Text(product.category),
          Text(product.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return Text(product.quantity.toString());
                },
              ),
              SizedBox(
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
                    icon: Icon(
                      Icons.remove,
                      color: Colors.white,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
