import 'package:app_dimonis/widgets/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color color = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informació de l\'usuari'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage('assets/demon.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: color),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  FirebaseAuth.instance.currentUser!.displayName ??
                      'NOM COMPLET',
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(FirebaseAuth.instance.currentUser!.email!,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // FirebaseAuth.instance.currentUser!
                    // .updateDisplayName('Esteve Llobera Suau');
                    // print(FirebaseAuth.instance.currentUser!.metadata);
                  },
                  child: const Text('Edit profile',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Settings",
                  icon: Icons.settings,
                  color: color,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Billing Details",
                  icon: Icons.wallet,
                  color: color,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "User Management",
                  icon: Icons.person,
                  color: color,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: Icons.info,
                  color: color,
                  onPress: () {}),
              ProfileMenuWidget(
                title: "Logout",
                icon: Icons.login_rounded,
                textColor: Colors.red,
                endIcon: false,
                color: color,
                onPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.infoReverse,
                    buttonsBorderRadius: const BorderRadius.all(
                      Radius.circular(2),
                    ),
                    dismissOnTouchOutside: true,
                    dismissOnBackKeyPress: false,
                    headerAnimationLoop: false,
                    animType: AnimType.topSlide,
                    title: 'Tanca la sessió',
                    desc: 'Estau segurs de tancar la sessió?',
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ).show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
