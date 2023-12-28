import 'package:app_dimonis/widgets/only_admin_widget.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          Center(
            child: Container(
              width: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 134, 129, 129),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: RichText(
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
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pages_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Cuenta'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'user_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'settings_screen');
            },
          ),
          OnlyAdminWidget(
            child: ListTile(
              leading: const Icon(Icons.pages_outlined),
              title: const Text('Crea Gincana'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/createGinkana');
              },
            ),
          ),
          OnlyAdminWidget(
            child: ListTile(
              leading: const Icon(Icons.person_add_alt_outlined),
              title: const Text('Crea Dimoni'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'crear_dimoni');
              },
            ),
          ),
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
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/menu-img.jpg'), fit: BoxFit.cover),
      ),
      child: Container(),
    );
  }
}
