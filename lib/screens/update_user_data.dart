import 'package:app_dimonis/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    if (displayName != FirebaseAuth.instance.currentUser!.displayName) {
      var userProvider =
          Provider.of<FireBaseProvider>(context, listen: false).usersProvider;
      userProvider.setDisplayName(displayName);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('S\'ha actualitzat el nom d\'usuari correctament.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nom d\'usuari és el mateix.'),
        ),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                        child:
                            const Image(image: AssetImage("assets/demon.png"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red),
                      child: const Icon(Icons.camera_alt_outlined,
                          color: Colors.black, size: 20),
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
                          return 'Introdueix el nom d\'usuari';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: "Nom usuari",
                          hintText: "Nom usuari",
                          border: OutlineInputBorder()),
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
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: "Correu",
                          hintText: "Correu",
                          border: OutlineInputBorder()),
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
                        labelText: "Password",
                        hintText: "Password",
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
                            : Text("Guardar cambios".toUpperCase()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Joined ',
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
                          child: const Text('Delete Account'),
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
    const List<String> months = [
      'gener',
      'febrer',
      'març',
      'abril',
      'maig',
      'juny',
      'juliol',
      'agost',
      'setembre',
      'octubre',
      'novembre',
      'desembre',
    ];
    return months[month - 1];
  }
}
