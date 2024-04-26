import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    return SalomonBottomBar(
      duration: const Duration(milliseconds: 1200),
      currentIndex: currentIndex,
      onTap: (i) => uiProvider.selectMenuOpt = i,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.map),
          title: const Text("Mapa"),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.people),
          title: const Text("Dimonis"),
          selectedColor: Colors.pink,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.games_outlined),
          title: const Text("Gimcanes"),
          selectedColor: Colors.orange,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.calendar_month_outlined),
          title: const Text("Calendari"),
          selectedColor: Colors.cyan,
        ),
      ],
    );
  }
}
