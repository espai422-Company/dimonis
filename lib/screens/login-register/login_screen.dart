import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/screens/login-register/components_login.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:app_dimonis/widgets/show_toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                LoginHeaderWidget(
                  title: AppLocalizations.of(context)!.welcomeBack,
                  subtitle: AppLocalizations.of(context)!.lema,
                ),
                const LoginForm(),
                LoginFooterWidget(
                  controller: controller,
                  textAccount: AppLocalizations.of(context)!.noAccount,
                  textFunction: AppLocalizations.of(context)!.signupJunt,
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
      errorToastification(context, AppLocalizations.of(context)!.loginError,
          e.message ?? 'UNKNOWN LOGIN ERROR');
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
                  return AppLocalizations.of(context)!.noEmailInput;
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_outlined),
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.email,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.visiblePassword,
              controller: _passController,
              obscureText: visiblePasswd,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.noPasswordInput;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.password,
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
                  child: Text(AppLocalizations.of(context)!.forgetPassword)),
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
                    : Text(
                        AppLocalizations.of(context)!.loginJunt.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
