import 'package:app_dimonis/screens/login-register/components_login.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:app_dimonis/widgets/show_toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                LoginHeaderWidget(
                  title: AppLocalizations.of(context)!.getOnBoard,
                  subtitle: AppLocalizations.of(context)!.newProfile,
                ),
                const SignUpFormWidget(),
                LoginFooterWidget(
                  controller: controller,
                  textAccount: AppLocalizations.of(context)!.yesAccount,
                  textFunction: AppLocalizations.of(context)!.loginJunt,
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

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passController.value.text;
    final user = _userNameController.value.text;

    setState(() => _loading = true);

    if (passNotifier.value != PasswordStrength.secure) {
      warningToastification(
          context,
          AppLocalizations.of(context)!.passwordTooWeak,
          AppLocalizations.of(context)!.passwordRequirements);
      setState(() => _loading = false);
      return;
    }

    try {
      await Auth().registerWithEmailAndPassword(email, password, user);
      Navigator.of(context).pushReplacementNamed('/');
      _emailController.text = '';
      _passController.text = '';
      _userNameController.text = '';
    } on FirebaseAuthException catch (e) {
      errorToastification(context, AppLocalizations.of(context)!.registerError,
          e.message ?? 'UNKNOWN SING UP ERROR');
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              controller: _userNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.noUsernameInput;
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_outlined),
                  labelText: AppLocalizations.of(context)!.username,
                  hintText: AppLocalizations.of(context)!.username,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
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
              onChanged: (value) {
                passNotifier.value = PasswordStrength.calculate(text: value);
              },
            ),
            const SizedBox(height: 10),
            PasswordStrengthChecker(
              strength: passNotifier,
            ),
            const SizedBox(height: 10),
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
                        AppLocalizations.of(context)!.signupJunt.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
