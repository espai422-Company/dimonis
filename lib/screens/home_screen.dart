import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/models/progres.dart';
import 'package:app_dimonis/screens/auth_screen.dart';
import 'package:app_dimonis/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!;
          if (user.emailVerified) {
            return const HomeWidget();
          } else {
            // return HomeScreen();
            return const VerifyEmail();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  //Use this to Log Out user
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Sign Out'),
              ),
              ElevatedButton(
                onPressed: () {
                  DBConnection().readFromDatabase();
                  // DBConnection().writeToDatabase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Print dimonis'),
              ),
              Text(FirebaseAuth.instance.currentUser!.uid),
              // image url

              provesDimoni(),
              provesGimcana(context),
              provesProgres(),
            ],
          ),
        ),
      ),
    );
  }

  Widget provesDimoni() {
    var dimoni = Dimoni(
      nom: 'Gay',
      image:
          'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Besso2.jpg?alt=media&token=8eff69df-c8ce-4af1-b0d9-7021985158a5',
      description: 'No desc',
      id: '-Nm5_WSR-_xqOnBENWiO',
    );
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        const Text('Proves Dimoni'),
        ElevatedButton(
          onPressed: () {
            // dimoni.delete();
            // dimoni.save();
            Dimoni.getDimoni('-Nm5_neOWgKzWuFpQ3Ve')
                .then((value) => print(value.nom));

            Dimoni.getDimonis().then((value) => print(value.length));
          },
          child: Text('Test Dimoni'),
        ),
      ],
    );
  }

  Widget provesGimcana(context) {
    // exemple crear una gimaca nova i guardarla
    var gimcama = Gimcama(
      id: '-Nm5j494CRO4J5ir1DXE', // Comentar per crear una nova gimcama, aixo es per modificar una existent
      nom: 'Gimcama1',
      start: DateTime.now(),
      end: DateTime.now().add(Duration(days: 1)),
    );
    return Column(
      children: [
        const Text('Proves Gimcama'),
        ElevatedButton(
          onPressed: () async {
            // gimcama.save();
            // gimcama.addDimoni(
            //     await Dimoni.getDimoni('-Nm5_neOWgKzWuFpQ3Ve'), '100', '200');
            // gimcama.getDimonis().then((value) => print(value.length));
            // gimcama
            //     .removeDimoni(await Dimoni.getDimoni('-Nm5apaQ6dyOuRsSE66M'));
          },
          child: Text('Test Gimcana'),
        ),
        ElevatedButton(
          onPressed: () {},
          // => Navigator.pushNamed(context, '/createGinkana'),
          child: Text('Crea Gimcana'),
        ),
      ],
    );
  }

  Widget provesProgres() {
    return Column(
      children: [
        const Text('Proves Progres'),
        ElevatedButton(
          onPressed: () async {
            var progress = Progress(gimcanaId: '-Nm5j494CRO4J5ir1DXE');
            // progress.gimcana_id = '-Nm5j494CRO4J5ir1DXE';
            await progress
                .findDimoni(await Dimoni.getDimoni('-Nm5apaQ6dyOuRsSE66M'));
            progress.getProgress().then((value) => print(value.length));
          },
          child: Text('Test Progres'),
        ),
      ],
    );
  }
}
