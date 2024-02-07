import 'package:app_dimonis/services/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Recupera la contrassenya'),
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
                const Text(
                  'Recupera la contrassenya',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Introdueix el correu per canviar la contrassenya:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introdueix el teu correu';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Email",
                      hintText: "Email",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    handleSubmit();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Envia'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
