import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestionstock/bloc/toggleicon_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestionstock/screens/regsiter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailValue = '';
  String _passwordValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SvgPicture.asset('images/login.svg',
                      width: 200, height: 200
                      // height: 500,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _emailValue = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<ToggleiconBloc, ToggleiconState>(
                  builder: (context, state) {
                    return TextFormField(
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
                                : const FaIcon(FontAwesomeIcons.eyeSlash)),
                        labelText: 'Mot de passe ',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordValue = value!;
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
                        _formKey.currentState!.save();
                        // Utilisez _inputValue comme vous le souhaitez
                        print('Input Value: $_emailValue');
                        print('Input Value: $_passwordValue');
                      }
                    },
                    child: Text('Connexion'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n’avez pas de compte ?',
                      style: TextStyle(fontSize: 10),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegsiterScreen()));
                        },
                        child: Text(
                          'inscrivez vous ici',
                          style:
                              TextStyle(fontSize: 10, color: Color(0xff0C5E69)),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
