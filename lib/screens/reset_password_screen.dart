import 'package:app_dimonis/auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/reset_password.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Reset your password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Text('Put the email to reset the password:'),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                //Assign controller
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  focusColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String? test =
                        await Auth().resetPassword(_emailController.value.text);
                    if (test != null) {
                      showDialog(
                        // barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            icon: const Icon(Icons.info_outline),
                            title: Text(test),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Acceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Send'),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
