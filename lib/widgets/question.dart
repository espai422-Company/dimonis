import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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
    title: 'Resposta',
    body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInImage(
            height: 200,
            placeholder: const AssetImage('assets/LoadingDimonis-unscreen.gif'),
            image: NetworkImage(nextDimoni!.image),
          ),
          CoolDropdown<String>(
            controller: dimonisDropdownController,
            dropdownList: dimonis,
            onChange: (value) {
              selectedDimoni = value;
            },
            resultOptions: const ResultOptions(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 200,
              icon: SizedBox(
                width: 10,
                height: 10,
                child: CustomPaint(
                  painter: DropdownArrowPainter(),
                ),
              ),
              render: ResultRender.all,
              placeholder: 'Select Dimoni',
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
        ],
      ),
    ),
    btnOkOnPress: () {
      if (selectedDimoni.isNotEmpty) {
        submit(selectedDimoni, context);
      } else {
        toastification.show(
          alignment: Alignment.bottomCenter,
          style: ToastificationStyle.flatColored,
          type: ToastificationType.error,
          context: context,
          title: const Text(
            'Selecciona un Dimoni',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          autoCloseDuration: const Duration(seconds: 6),
        );
      }
    },
  ).show();
}
