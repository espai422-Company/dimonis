import 'package:app_dimonis/screens/login-register/components_login.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingUpScreen extends StatelessWidget {
  const SingUpScreen({super.key, required this.controller});

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
                  title: "Get on board,",
                  subtitle: "Create your profile to start.",
                ),
                const SignUpFormWidget(),
                LoginFooterWidget(
                  controller: controller,
                  textAccount: "Already have an account? ",
                  textFunction: "Login",
                  page: 0,
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

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidget();
}

class _SignUpFormWidget extends State<SignUpFormWidget> {
  bool _loading = false;
  bool visiblePasswd = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passController.value.text;
    final user = _userNameController.value.text;

    setState(() => _loading = true);

    try {
      await Auth().registerWithEmailAndPassword(email, password, user);
      Navigator.of(context).pushReplacementNamed('/');
      _emailController.text = '';
      _passController.text = '';
      _userNameController.text = '';
    } on FirebaseAuthException catch (e) {
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
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _userNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introdueix el nom d\'usuari';
                }
                return null;
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Nom d'usuari",
                  hintText: "Nom d'usuari",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextFormField(
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
                    : Text("Signup".toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
