import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/screens/calendar_screen.dart';
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
              const CircularProgressIndicator(),
              Container(height: 20),
              const Text("Loading data, please wait...")
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'user_screen');
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 60,
                width: 60,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage('assets/user.png'),
                      image: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL ??
                            'https://raw.githubusercontent.com/espai422-Company/dimonis/master/assets/user.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: const SideMenu(),
        bottomNavigationBar: const CustomNavigationBar(),
        body: const _HomeScreenBody());
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

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

      case 3:
        return const CalendarScreen();

      default:
        return const MapsScreen();
    }
  }
}
