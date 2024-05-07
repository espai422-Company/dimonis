import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    const Color color = Color.fromARGB(255, 190, 185, 185);

    final languageDropdownController = DropdownController();

    List<CoolDropdownItem<Locale>> idiomes = [
      CoolDropdownItem<Locale>(
          value: const Locale('es'),
          label: AppLocalizations.of(context)!.spanish,
          icon: Image.asset("assets/banderes/es.png")),
      CoolDropdownItem<Locale>(
          value: const Locale('ca'),
          label: AppLocalizations.of(context)!.catalan,
          icon: Image.asset("assets/banderes/ca.png")),
      CoolDropdownItem<Locale>(
          value: const Locale('en'),
          label: AppLocalizations.of(context)!.english,
          icon: Image.asset("assets/banderes/en.png")),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appBarSettingsTitle),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.appearance,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.red,
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: Preferences.isDarkMode,
                      title: Text(AppLocalizations.of(context)!.darkMode),
                      onChanged: (value) {
                        Preferences.isDarkMode = value;
                        value
                            ? themeProvider.setDarkMode()
                            : themeProvider.setLightMode();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.initialGuide,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.red,
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: Preferences.guiaInicial,
                      title: Text(AppLocalizations.of(context)!
                          .initialGuideDescription),
                      onChanged: (value) {
                        setState(() {
                          Preferences.guiaInicial = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.red,
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              CoolDropdown<Locale>(
                defaultItem: idiomes.firstWhere((element) =>
                    element.value.languageCode == Preferences.language),
                controller: languageDropdownController,
                dropdownList: idiomes,
                onChange: (value) {
                  languageProvider.locale = value;
                  Preferences.language = value.languageCode;
                  languageDropdownController.close();
                  setState(() {});
                },
                resultOptions: ResultOptions(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  // width: 200,
                  icon: const SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: DropdownArrowPainter(),
                    ),
                  ),
                  render: ResultRender.all,
                  placeholder: AppLocalizations.of(context)!.selectLanguage,
                  isMarquee: true,
                ),
                dropdownOptions: const DropdownOptions(
                  top: 20,
                  height: 400,
                  gap: DropdownGap.all(5),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  align: DropdownAlign.left,
                  animationType: DropdownAnimationType.size,
                ),
                dropdownTriangleOptions: const DropdownTriangleOptions(
                  width: 20,
                  height: 30,
                  align: DropdownTriangleAlign.left,
                  borderRadius: 3,
                  left: 20,
                ),
                dropdownItemOptions: const DropdownItemOptions(
                  isMarquee: true,
                  mainAxisAlignment: MainAxisAlignment.end,
                  render: DropdownItemRender.all,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
