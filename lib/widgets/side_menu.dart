import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/widgets/only_admin_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'element_list.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

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
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

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
    const Color color = Colors.cyan;

    return Column(
      children: [
        ProfileMenuWidget(
          title: "Inici",
          icon: Icons.home,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ProfileMenuWidget(
          title: "Compte",
          icon: Icons.account_circle,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'user_screen');
          },
        ),
        ProfileMenuWidget(
          title: "Get Prime",
          icon: Icons.star_border_purple500,
          color: color,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/upgrade_to_premium');
          },
        ),
        ProfileMenuWidget(
          title: "Configuració",
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
            title: "Nova gimcana",
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
            title: "Nou dimoni",
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
          title: "Logout",
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
    );
  }
}
