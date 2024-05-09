import 'package:app_dimonis/providers/providers.dart';
import 'package:app_dimonis/widgets/show_toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _displayNameController.text =
        FirebaseAuth.instance.currentUser!.displayName ?? '';
    _emailController.text = FirebaseAuth.instance.currentUser!.email ?? '';
  }

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final displayName = _displayNameController.value.text;

    setState(() => _loading = true);

    var userProvider =
        Provider.of<FireBaseProvider>(context, listen: false).usersProvider;
    userProvider.setDisplayName(displayName);
    userProvider.setPhotoURL(iconUser);

    succesToastification(
        context,
        AppLocalizations.of(context)!.changesSavedTitle,
        AppLocalizations.of(context)!.changesSavedMessage);

    setState(() => _loading = false);
  }

  String iconUser = FirebaseAuth.instance.currentUser!.photoURL ??
      'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon0.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/LoadingDimonis-unscreen.gif'),
                            image: NetworkImage(iconUser))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'icon_picker_user')
                            .then((value) {
                          setState(() {
                            if (value != null) {
                              iconUser =
                                  '$value?timestamp=${DateTime.now().millisecondsSinceEpoch}';
                            }
                          });
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _displayNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.noUsernameInput;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: AppLocalizations.of(context)!.username,
                          hintText: AppLocalizations.of(context)!.username,
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: _emailController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Introdueix el correu';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: AppLocalizations.of(context)!.email,
                          hintText: AppLocalizations.of(context)!.email,
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: _passwordController,
                      obscureText: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Introdueix la teva contrassenya';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.fingerprint),
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: AppLocalizations.of(context)!.password,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.visibility_outlined),
                          // icon: visiblePasswd
                          //     ? const Icon(Icons.visibility_outlined)
                          //     : const Icon(Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => handleSubmit(),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppLocalizations.of(context)!
                                .saveChanges
                                .toUpperCase()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '${AppLocalizations.of(context)!.joined} ',
                            children: [
                              TextSpan(
                                  text:
                                      '${FirebaseAuth.instance.currentUser!.metadata.creationTime!.day} ${_getMonth(FirebaseAuth.instance.currentUser!.metadata.creationTime!.month)} ${FirebaseAuth.instance.currentUser!.metadata.creationTime!.year}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child:
                              Text(AppLocalizations.of(context)!.deleteAccount),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonth(int month) {
    List<String> months = [
      AppLocalizations.of(context)!.gener,
      AppLocalizations.of(context)!.febrer,
      AppLocalizations.of(context)!.marc,
      AppLocalizations.of(context)!.abril,
      AppLocalizations.of(context)!.maig,
      AppLocalizations.of(context)!.juny,
      AppLocalizations.of(context)!.juliol,
      AppLocalizations.of(context)!.agost,
      AppLocalizations.of(context)!.setembre,
      AppLocalizations.of(context)!.octubre,
      AppLocalizations.of(context)!.novembre,
      AppLocalizations.of(context)!.desembre,
    ];
    return months[month - 1];
  }
}
