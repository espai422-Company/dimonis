import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<FireBaseProvider>(context, listen: false).usersProvider;

    const Color color = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.infoUsuari),
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
                      child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/demon.png',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                        textAlign: TextAlign.center,
                        FirebaseAuth.instance.currentUser!.displayName ??
                            'NOM COMPLET',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  userProvider.currentUser.privileges == 'prime'
                      ? const Icon(
                          Icons.star,
                          color: Colors.red,
                        )
                      : const SizedBox(),
                ],
              ),
              Text(FirebaseAuth.instance.currentUser!.email!,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'update_user_data_screen')
                        .then((value) => setState(() {}));
                  },
                  child: Text(AppLocalizations.of(context)!.editProfile,
                      style: const TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.settings,
                  icon: Icons.settings,
                  color: color,
                  onPress: () {
                    Navigator.pushNamed(context, 'settings_screen');
                  }),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.billingDetails,
                  icon: Icons.wallet,
                  color: color,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.userManagement,
                  icon: Icons.person,
                  color: color,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.information,
                  icon: Icons.info,
                  color: color,
                  onPress: () {
                    Navigator.pushNamed(context, 'info_app_screen');
                  }),
              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.logout,
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
                    title: AppLocalizations.of(context)!.logoutDialogTitle,
                    desc: AppLocalizations.of(context)!.logoutDialogDescription,
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
