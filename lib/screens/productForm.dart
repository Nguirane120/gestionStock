import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:image_picker/image_picker.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
bool _isLoading = false;
  final picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            debugPrint(state.error);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is ProductLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product added successfully")));
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category')),
              TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              _selectedImage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Choose Image'),
                        ),
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.file(_selectedImage!, height: 100),
                          ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Choose Image'),
                    ),
              ElevatedButton(
                onPressed: _isLoading ? null : () async  {
                    setState(() {
                  _isLoading = true; // Démarrer le chargement
                });


                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (_selectedImage != null) {
                
                    context.read<ProductBloc>().add(AddProductEvent(
                          _nameController.text,
                          _categoryController.text,
                          _descriptionController.text,
                          int.parse(_quantityController.text),
                          _selectedImage!,
                          currentUser?.email ?? "Unknown user",
                        ),
                        );
                         setState(() {
                   _isLoading = false; // Arrêter le chargement
                });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select an image")));
                  }
                },
                child: _isLoading // Afficher un loader si en chargement
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    )
                  : Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
