import 'package:app_dimonis/widgets/gimcama_list.dart';
import 'package:app_dimonis/widgets/gimcana_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';

class GimcamaScreen extends StatefulWidget {
  const GimcamaScreen({super.key});

  @override
  State<GimcamaScreen> createState() => _GimcamaScreenState();
}

class _GimcamaScreenState extends State<GimcamaScreen> {
  String selectedOption = 'Actuals';
  List<String> options = ['Totes', 'Proximes', 'Actuals', 'Anteriors'];

  @override
  Widget build(BuildContext context) {
    // var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);
    var progressProvider =
        Provider.of<FireBaseProvider>(context, listen: true).progressProvider;

    if (progressProvider.gimcanaId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  value: selectedOption,
                  items: options.map((String option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                ),
              ),
              Expanded(
                child: GimcamaList(selectedOption: selectedOption),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: GimcamaData());
    }
  }
}
