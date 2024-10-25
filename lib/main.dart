import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestionstock/bloc/toggleicon_bloc.dart';
import 'package:gestionstock/screens/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToggleiconBloc>(create: (contex) => ToggleiconBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Color(0xff0C5E69),
            elevation: 4, 
            centerTitle: true,
            iconTheme:
                IconThemeData(color: Color(0xfffFFFFFF)),
            titleTextStyle: TextStyle(
              color: Color(0xfffFFFFFF), 
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:  const Color(0xff0C5E69),
              foregroundColor:  const Color(0xfffFFFFFF),
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
