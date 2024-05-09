import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/widgets/show_toastification.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void question(BuildContext context, nextDimoni, submit) {
  List<CoolDropdownItem<String>> dimonis = [];
  final dimonisDropdownController = DropdownController();
  String selectedDimoni = '';

  Provider.of<FireBaseProvider>(context, listen: false)
      .dimoniProvider
      .dimonis
      .forEach((element) {
    dimonis.add(
      CoolDropdownItem<String>(
        value: element.nom,
        label: element.nom,
      ),
    );
  });

  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.bottomSlide,
    title: AppLocalizations.of(context)!.answer,
    body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInImage(
            height: 200,
            placeholder: const AssetImage('assets/LoadingDimonis-unscreen.gif'),
            image: NetworkImage(nextDimoni!.image),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: CoolDropdown<String>(
                controller: dimonisDropdownController,
                dropdownList: dimonis,
                onChange: (value) {
                  selectedDimoni = value;
                },
                resultOptions: ResultOptions(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 200,
                  icon: const SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: DropdownArrowPainter(),
                    ),
                  ),
                  render: ResultRender.all,
                  placeholder: AppLocalizations.of(context)!.selectDemon,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  render: DropdownItemRender.all,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    btnOkOnPress: () {
      if (selectedDimoni.isNotEmpty) {
        submit(selectedDimoni, context);
      } else {
        warningToastification(
            context,
            AppLocalizations.of(context)!.selectDemon,
            AppLocalizations.of(context)!.selectDemonToCheckResult);
      }
    },
  ).show();
}
