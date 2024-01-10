import 'package:app_dimonis/widgets/gimcama_list.dart';
import 'package:app_dimonis/widgets/gimcana_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';

class GimcamaScreen extends StatefulWidget {
  const GimcamaScreen({super.key});

  @override
  State<GimcamaScreen> createState() => _GimcamaScreenState();
}

class _GimcamaScreenState extends State<GimcamaScreen> {
  String selectedOption = 'Proximes';
  List<String> options = ['Totes', 'Proximes', 'Anteriors'];

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);

    if (playing.currentGimcana == null) {
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
      return Center(child: GimcamaData());
    }
  }
}
