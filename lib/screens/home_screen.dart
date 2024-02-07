import 'package:app_dimonis/providers/firebase_provider.dart';
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
    FireBaseProvider firebaseProvider = Provider.of<FireBaseProvider>(context);
    if (!firebaseProvider.loaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Container(height: 20),
              Text("Loading data, please wait...")
            ],
          ),
        ),
      );
    }
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
                      title: const Text('Es tancarà la sessió!'),
                      content: const Text('Dessitja continuar?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel·la'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Tanca sessió'),
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
