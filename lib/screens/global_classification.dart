import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_provider.dart';
import '../providers/global_classification_provider.dart';
import '../widgets/side_menu.dart';

class GlobalClassification extends StatefulWidget {
  const GlobalClassification({super.key});

  @override
  State<GlobalClassification> createState() => _GlobalClassificationState();
}

class _GlobalClassificationState extends State<GlobalClassification> {
  @override
  void initState() {
    final users = Provider.of<FireBaseProvider>(context, listen: false).usersProvider.users;
    final classification = Provider.of<GlobalClassificationProvider>(context, listen: false);
    classification.loadAllUsers(users);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<FireBaseProvider>(context).usersProvider.users;
    final classification = Provider.of<GlobalClassificationProvider>(context);
    final classificationList = classification.getRanking();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificación global'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                classification.loadAllUsers(users);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: classificationList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(classificationList[index].user.displayName),
              subtitle: Text(classificationList[index].points.toString()),
            );
          },
        ),
      ),
    );
  }
}
