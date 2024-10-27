import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/bloc/auth_bloc.dart';
import 'package:gestionstock/bloc/block_product_bloc.dart';
import 'package:gestionstock/bloc/toggleicon_bloc.dart';
import 'package:gestionstock/firebase_options.dart';
import 'package:gestionstock/repository/productRepository.dart';
import 'package:gestionstock/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToggleiconBloc>(create: (contex) => ToggleiconBloc()),
        BlocProvider<AuthBloc>(create: (contex) => AuthBloc()),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            ProductRepository(
              FirebaseFirestore.instance,
              FirebaseStorage.instance,
            ),
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Color(0xff0C5E69),
            elevation: 4,
            iconTheme: IconThemeData(color: Color(0xfffFFFFFF)),
            titleTextStyle: TextStyle(
              color: Color(0xfffFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0C5E69),
              foregroundColor: const Color(0xfffFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(color: Color(0xff0C5E69)),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
