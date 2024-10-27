import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestionstock/bloc/bloc/auth_bloc.dart';
import 'package:gestionstock/bloc/toggleicon_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestionstock/screens/home.dart';
import 'package:gestionstock/screens/regsiter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isConnected = false;
  StreamSubscription? internetSuscription;
  @override
  void initState() {
    internetSuscription = InternetConnection().onStatusChange.listen((event) {
      print(event);
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          break;
        default:
          setState(() {
            isConnected = false;
          });
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    internetSuscription!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Erreur d\'authentification: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 60),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SvgPicture.asset('images/login.svg',
                        width: 200, height: 200),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ToggleiconBloc, ToggleiconState>(
                    builder: (context, state) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: (state as ToggleiconInitial).isOn,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<ToggleiconBloc>()
                                  .add(ToglleSuffixIconEvent());
                            },
                            icon: (state as ToggleiconInitial).isOn
                                ? const FaIcon(FontAwesomeIcons.eye)
                                : const FaIcon(FontAwesomeIcons.eyeSlash),
                          ),
                          labelText: 'Mot de passe ',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthSignInRequested(email, password));
                        }
                      },
                      child: const Text('Connexion'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Vous n\' avez pas de ccompte ?',
                        style: TextStyle(fontSize: 10),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegsiterScreen()),
                          );
                        },
                        child: const Text(
                          'inscrivez-vous ici',
                          style:
                              TextStyle(fontSize: 10, color: Color(0xff0C5E69)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
