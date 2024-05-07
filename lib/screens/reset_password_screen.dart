import 'package:app_dimonis/services/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    handleSubmit() async {
      if (!formKey.currentState!.validate()) return;
      final email = emailController.value.text;

      String? test = await Auth().resetPassword(email);

      if (test != null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: false,
          animType: AnimType.topSlide,
          title: 'ERROR',
          desc: test,
          showCloseIcon: true,
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/reset_password.png',
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.resetPasswordTitle,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppLocalizations.of(context)!.resetPasswordSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.noEmailInput;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.email,
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      handleSubmit();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(AppLocalizations.of(context)!.submitButton),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
