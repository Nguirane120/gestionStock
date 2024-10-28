import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/block_product_event.dart';
import 'package:gestionstock/bloc/block_product_state.dart';
import 'package:gestionstock/models/product.dart';
import 'package:gestionstock/screens/home.dart';
import 'package:image_picker/image_picker.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;
  bool isEditing = false;
  final picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEditing = true;
      _nameController.text = widget.product!.name;
      _categoryController.text = widget.product!.category;
      _descriptionController.text = widget.product!.description;
      _quantityController.text = widget.product!.quantity.toString();
      // Initialize _selectedImage only if you want to allow changing it during edit
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier produit' : 'Ajouter produit'),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            setState(() {
              _isLoading = false; // Ensure loading state is reset
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is ProductLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isEditing
                    ? "Produit modifié avec succès"
                    : "Produit ajouté avec succès")));
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              widget.product?.imageUrl != null
                  ? Image.network(
                      widget.product!.imageUrl,
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : _selectedImage != null
                      ? Column(
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('Choisir nouvelle image'),
                            ),
                            Image.file(_selectedImage!, height: 100),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Choisir une image'),
                        ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        User? currentUser = FirebaseAuth.instance.currentUser;

                        if (!isEditing) {
                          if (_selectedImage != null) {
                            context.read<ProductBloc>().add(AddProductEvent(
                                  _nameController.text,
                                  _categoryController.text,
                                  _descriptionController.text,
                                  int.parse(_quantityController.text),
                                  _selectedImage!,
                                  currentUser?.email ?? "Unknown user",
                                ));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Veuillez sélectionner une image")),
                            );
                          }
                        } else {
                          // Mode édition
                          if (widget.product != null) {
                            context.read<ProductBloc>().add(EditProductEvent(
                                  productId: widget.product!.id,
                                  name: _nameController.text,
                                  category: _categoryController.text,
                                  description: _descriptionController.text,
                                  quantity: int.parse(_quantityController.text),
                                  imageUrl: _selectedImage != null
                                      ? _selectedImage!.path
                                      : widget.product!.imageUrl,
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Produit introuvable pour l'édition")),
                            );
                          }
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      )
                    : Text(isEditing ? 'Modifier produit' : 'Ajouter produit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
