import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestionstock/bloc/bloc/auth_bloc.dart';
import 'package:gestionstock/bloc/toggleicon_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestionstock/screens/login.dart';

class RegsiterScreen extends StatefulWidget {
  const RegsiterScreen();

  @override
  State<RegsiterScreen> createState() => _RegsiterScreenState();
}

class _RegsiterScreenState extends State<RegsiterScreen> {
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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
                    child: SvgPicture.asset('images/signup.svg',
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
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Appelle la fonction de connexion ou d'inscription ici
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthSignUpRequested(email, password));
                        }
                      },
                      child: Text('Inscription'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous avez déjà un compte ?',
                        style: TextStyle(fontSize: 10),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Connectez-vous ici',
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
