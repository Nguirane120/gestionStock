import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/bloc/auth_bloc.dart';
import 'package:gestionstock/screens/login.dart';
import 'package:gestionstock/screens/product.dart';
import 'package:gestionstock/screens/productForm.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestion des stocks'),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(AuthSignOutRequested());
                  },
                  icon: Icon(Icons.logout),
                );
              },
            ),
          ],
        ),
        body: ProductListScreen(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
