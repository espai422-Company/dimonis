import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/screens/login-register/components_login.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeaderWidget(
                  title: "Welcome Back,",
                  subtitle: "Make it work, make it right, moke it fast.",
                ),
                const LoginForm(),
                LoginFooterWidget(
                  controller: controller,
                  textAccount: "Don't have an account? ",
                  textFunction: "Signup",
                  page: 1,
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: const FloatingButtonTheme(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _loading = false;
  bool visiblePasswd = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passController.value.text;

    setState(() => _loading = true);

    try {
      await Auth().signInWithEmailAndPassword(email, password);
      if (Preferences.guiaInicial) {
        Navigator.of(context).pushReplacementNamed('guia_inicial');
      } else {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      toastification.show(
        // alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.error,
        context: context,
        title: const Text(
          'Login error',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(e.message!),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'ERROR',
              message: e.message!,
              contentType: ContentType.failure,
            ),
          ),
        );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // autovalidateMode: AutovalidateMode.always,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introdueix el teu correu';
                }
                return null;
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email",
                  hintText: "Email",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.visiblePassword,
              controller: _passController,
              obscureText: visiblePasswd,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introdueix la teva contrassenya';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: "Password",
                hintText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      visiblePasswd = !visiblePasswd;
                    });
                  },
                  icon: visiblePasswd
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reset_password_screen');
                  },
                  child: const Text("Forget password?")),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => handleSubmit(),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text("Login".toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
