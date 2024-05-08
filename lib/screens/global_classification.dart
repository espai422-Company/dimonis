import 'package:app_dimonis/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final users = Provider.of<FireBaseProvider>(context, listen: false)
        .usersProvider
        .users;
    final classification =
        Provider.of<GlobalClassificationProvider>(context, listen: false);
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
        title: Text(AppLocalizations.of(context)!.globalClassification),
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
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: classificationList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: index == 0
                      ? const Color.fromARGB(137, 216, 187, 26)
                      : (index == 1
                          ? const Color.fromARGB(127, 205, 206, 205)
                          : (index == 2
                              ? const Color.fromARGB(123, 187, 121, 0)
                              : Preferences.isDarkMode
                                  ? const Color.fromARGB(137, 255, 124, 124)
                                  : const Color.fromARGB(155, 255, 127, 127))),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: index == 0
                        ? 5
                        : (index == 1 ? 4 : (index == 2 ? 3 : 3)),
                    color: index == 0
                        ? const Color.fromARGB(255, 216, 188, 26)
                        : (index == 1
                            ? const Color.fromARGB(255, 205, 206, 205)
                            : (index == 2
                                ? const Color.fromARGB(255, 187, 121, 0)
                                : const Color.fromARGB(0, 255, 255, 255))),
                  )),
              child: ListTile(
                leading: ClipOval(
                    child: Image.network(classificationList[index]
                            .user
                            .photoUrl ??
                        "https://raw.githubusercontent.com/espai422-Company/dimonis/master/assets/user.png")),
                title: Row(
                  children: [
                    index == 0
                        ? Image.asset(
                            "assets/fotos_clasificacio/Oro.png",
                            width: 20,
                          )
                        : (index == 1
                            ? Image.asset(
                                "assets/fotos_clasificacio/Plata.png",
                                width: 20,
                              )
                            : (index == 2
                                ? Image.asset(
                                    "assets/fotos_clasificacio/Bronze.png",
                                    width: 20,
                                  )
                                : Container())),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child:
                            Text(classificationList[index].user.displayName)),
                  ],
                ),
                trailing: Text(classificationList[index].points.toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}
