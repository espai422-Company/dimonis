import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/language_provider.dart';
import 'package:app_dimonis/screens/login-register/main_view.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languageController = DropdownController();

    final List<CoolDropdownItem<Locale>> languages = [
      CoolDropdownItem<Locale>(
          value: const Locale('es'),
          label: "",
          icon: Image.asset("assets/banderes/es.png")),
      CoolDropdownItem<Locale>(
          value: const Locale('ca'),
          label: "",
          icon: Image.asset("assets/banderes/ca.png")),
      CoolDropdownItem<Locale>(
          value: const Locale('en'),
          label: "",
          icon: Image.asset("assets/banderes/en.png")),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 90,
              child: CoolDropdown<Locale>(
                defaultItem: languages.firstWhere((element) =>
                    element.value.languageCode == Preferences.language),
                controller: languageController,
                dropdownList: languages,
                onChange: (value) {
                  languageProvider.locale = value;
                  Preferences.language = value.languageCode;
                  languageController.close();
                },
                dropdownItemOptions: const DropdownItemOptions(
                  isMarquee: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  render: DropdownItemRender.all,
                  height: 50,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Image(image: AssetImage("assets/demon.png")),
                Column(
                  children: [
                    Text('DimonisGO',
                        style: Theme.of(context).textTheme.displaySmall),
                    Text(AppLocalizations.of(context)!.welcomeText,
                        style: Theme.of(context).textTheme.bodyLarge,
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
                        child: Text(
                            AppLocalizations.of(context)!.login.toUpperCase()),
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
                        child: Text(
                            AppLocalizations.of(context)!.signup.toUpperCase()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingButtonTheme(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
