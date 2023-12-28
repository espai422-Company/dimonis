import 'package:app_dimonis/auth.dart';
import 'package:flutter/material.dart';

class OnlyAdminWidget extends StatelessWidget {
  final Widget child;
  const OnlyAdminWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.isAdmin(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData && snapshot.data
            ? child
            : const Center(
                child: SizedBox.shrink(), // Most similar to null
              );
      },
    );
  }
}
