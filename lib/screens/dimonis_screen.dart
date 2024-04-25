import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:provider/provider.dart';

class DimonisScreen extends StatelessWidget {
  const DimonisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseProvider = Provider.of<FireBaseProvider>(context, listen: true);
    var gimcanaId = firebaseProvider.progressProvider.gimcanaId;
    return Scaffold(body: Builder(
      builder: (context) {
        if (gimcanaId == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: AnimatedTextKit(
                animatedTexts: [
                  // FadeAnimatedText(
                  //   'Fade First',
                  //   textStyle:
                  //       TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  // ),
                  // ScaleAnimatedText(
                  //   'Then Scale',
                  //   textStyle:
                  //       TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                  // ),
                  TypewriterAnimatedText(
                    'Unit a una gimcana per començar',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                repeatForever: true,
                pause: const Duration(milliseconds: 100),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              )),
            ],
          );
        }

        var playing =
            firebaseProvider.gimcanaProvider.getGimcanaById(gimcanaId);

        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: playing.ubications.length,
          itemBuilder: (_, int index) =>
              _Card(dimoni: playing.ubications[index].dimoni, context),
        );
      },
    ));
  }
}

class _Card extends StatelessWidget {
  final Dimoni dimoni;

  const _Card(context, {required this.dimoni});

  @override
  Widget build(BuildContext context) {
    var progressProvider =
        Provider.of<FireBaseProvider>(context, listen: true).progressProvider;
    print('progess');
    print(progressProvider.getProgressOfCurrentUser().discovers);
    return SizedBox(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/LoadingDimonis-unscreen.gif'),
                image: NetworkImage(
                  progressProvider
                          .getProgressOfCurrentUser()
                          .discovers
                          .any((element) => element.dimoni.id == dimoni.id)
                      ? dimoni.image
                      : 'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Dise-o-sin-t-tulo-unscreen.gif?alt=media&token=0a3a8b89-5e31-4f85-82e7-1c9b004cd7d2',
                ),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                progressProvider
                        .getProgressOfCurrentUser()
                        .discovers
                        .any((element) => element.dimoni.id == dimoni.id)
                    ? dimoni.nom
                    : '??????????',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                dimoni.description,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
