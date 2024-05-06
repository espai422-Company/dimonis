import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/widgets/only_admin_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'element_list.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          _DrawerHeader(),
          _DrawerBody(),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName:
          Text(FirebaseAuth.instance.currentUser!.displayName ?? 'NOM COMPLET'),
      accountEmail: Text(FirebaseAuth.instance.currentUser!.email ?? 'CORREU'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            FirebaseAuth.instance.currentUser!.photoURL ??
                'https://raw.githubusercontent.com/espai422-Company/dimonis/master/assets/user.png',
            fit: BoxFit.cover,
            width: 90,
            height: 90,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset(
                'assets/user.png',
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              );
            },
          ),
        ),
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/DrawerImage.jpg'), fit: BoxFit.cover),
      ),
    );
  }
}

class _DrawerBody extends StatelessWidget {
  const _DrawerBody();

  @override
  Widget build(BuildContext context) {
    const Color color = Color.fromARGB(255, 255, 126, 126);

    return Column(
      children: [
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuHome,
          icon: Icons.home,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuAccount,
          icon: Icons.account_circle,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'user_screen');
          },
        ),
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuClassification,
          icon: Icons.bar_chart,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'global_classification');
          },
        ),
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuGetPrime,
          icon: Icons.star_border_purple500,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/upgrade_to_premium');
          },
        ),
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuSettings,
          icon: Icons.settings_outlined,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'settings_screen');
          },
        ),
        const OnlyAdminWidget(child: Divider()),
        OnlyAdminWidget(
          child: ProfileMenuWidget(
            title: AppLocalizations.of(context)!.menuNewScavengerHunt,
            icon: Icons.add_location_alt_outlined,
            color: color,
            onPress: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'crear_gimcana',
                  arguments: FirebaseGimana(
                      nom: '',
                      start: DateTime.now(),
                      end: DateTime.now(),
                      dimonis: {},
                      propietari: '',
                      id: ''));
            },
          ),
        ),
        OnlyAdminWidget(
          child: ProfileMenuWidget(
            title: AppLocalizations.of(context)!.menuNewDemon,
            icon: Icons.person_add_alt_outlined,
            color: color,
            onPress: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'crear_dimoni');
            },
          ),
        ),
        const Divider(),
        ProfileMenuWidget(
          title: AppLocalizations.of(context)!.menuLogout,
          icon: Icons.login_rounded,
          textColor: Colors.red,
          endIcon: false,
          color: Colors.red,
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
    );
  }
}
