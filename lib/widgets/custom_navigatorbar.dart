import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)!.mapTitle),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.people),
          title: Text(AppLocalizations.of(context)!.dimonis),
          selectedColor: Colors.pink,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.games_outlined),
          title: Text(AppLocalizations.of(context)!.gimcana),
          selectedColor: Colors.orange,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.calendar_month_outlined),
          title: Text(AppLocalizations.of(context)!.calendar),
          selectedColor: Colors.cyan,
        ),
      ],
    );
  }
}
