import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/screens/gimcames_screen.dart';
import 'package:app_dimonis/screens/screens.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Dimonis',
                  style: TextStyle(fontSize: 20),
                ),
                TextSpan(
                  text: 'Go',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 30),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              // onPressed: () => FirebaseAuth.instance.signOut(),
              onPressed: () => {
                showDialog(
                  // barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: const Icon(Icons.info_outline),
                      title: const Text('Se va a cerrar sesión!'),
                      content: const Text('Desea continuar?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Continuar'),
                        ),
                      ],
                    );
                  },
                ),
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        drawer: const SideMenu(),
        bottomNavigationBar: CustomNavigationBar(),
        body: const _HomeScreenBody());
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    switch (currentIndex) {
      case 0:
        return const MapsScreen();

      case 1:
        return const DimonisScreen();

      case 2:
        return const GimcamaScreen();

      default:
        return const MapsScreen();
    }
  }
}
