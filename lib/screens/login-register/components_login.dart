import 'package:app_dimonis/widgets/github_sign_in_button.dart';
import 'package:app_dimonis/widgets/google_sign_in_button.dart';
import 'package:app_dimonis/widgets/microsoft_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget(
      {super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
              image: const AssetImage("assets/demon.png"),
              height: size.height * 0.2),
          Text(title,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget(
      {super.key,
      required this.controller,
      required this.textAccount,
      required this.textFunction,
      required this.page});

  final PageController controller;
  final String textAccount;
  final String textFunction;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.o),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              const MicrosoftSignInButton(),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GithubSignInButton(),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              controller.animateToPage(page,
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.ease);
            },
            child: Text.rich(
              TextSpan(
                  text: textAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                        text: textFunction,
                        style: const TextStyle(color: Colors.blue))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
