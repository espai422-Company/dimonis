import 'package:app_dimonis/screens/login-register/main_view.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Image(image: AssetImage("assets/demon.png")),
            Column(
              children: [
                Text('DimonisGO', style: Theme.of(context).textTheme.headline3),
                Text("Una aplicacion para entretener-se i jugar con amigos",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MainViewScreen(initialPageIndex: 0),
                        ),
                      );
                    },
                    child: Text("LOGIN".toUpperCase()),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MainViewScreen(initialPageIndex: 1),
                        ),
                      );
                    },
                    child: Text("SIGN UP".toUpperCase()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: const FloatingButtonTheme(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
