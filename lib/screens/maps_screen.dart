import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/global_classification_provider.dart';
import 'package:app_dimonis/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../models/state/progress.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationData>? _locationSubscription;
  Widget? _floatingActionButton;

  LatLng? _currentLocation;
  LatLng? _nextLocation;
  Dimoni? _nextDimoni;

  bool hasLocationPermission = true;
  bool locationServiceEnabled = true;
  late String _mapStyle;

  BitmapDescriptor _currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _nextLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    _locationRequest();
    setCustomMarker();
    _getNext();
    super.initState();

    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    final firebase = Provider.of<FireBaseProvider>(context);
    final classification = Provider.of<GlobalClassificationProvider>(context);

    final actualUser = firebase.usersProvider
        .getUserById(FirebaseAuth.instance.currentUser!.uid);
    final progressProvider = firebase.progressProvider;
    _getNext();

    if (progressProvider.gimcanaId == null) {
      return Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Unit a una gimcana per començar',
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      );
    } else if (progressProvider.timeToComplete[actualUser] != null) {
      classification.finishGimcana(progressProvider.gimcanaId!, actualUser.id);
      return Center(
          child: AnimatedTextKit(
        animatedTexts: [
          ScaleAnimatedText(
            'Enhorabona!',
            textStyle:
                const TextStyle(fontSize: 25.0, fontFamily: 'Canterbury'),
            duration: const Duration(milliseconds: 5000),
          ),
          ScaleAnimatedText(
            'Has completat la gimcana!',
            textStyle:
                const TextStyle(fontSize: 25.0, fontFamily: 'Canterbury'),
            duration: const Duration(milliseconds: 5000),
          ),
        ],
        pause: const Duration(milliseconds: 300),
        repeatForever: true,
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ));
    } else if (!hasLocationPermission) {
      return const Center(
        child: Text('No tenim permís per accedir a la localització'),
      );
    } else if (!locationServiceEnabled) {
      return const Center(
        child: Text('No tens el servei de localització activat'),
      );
    }

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _nextLocation ?? const LatLng(0, 0),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
          mapController.setMapStyle(_mapStyle);
        },
        markers: {
          if (_currentLocation != null)
            Marker(
              markerId: const MarkerId('current'),
              position: _currentLocation!,
              infoWindow: const InfoWindow(title: 'Tu'),
              icon: _currentLocationIcon,
            ),
          if (_nextLocation != null)
            Marker(
              markerId: const MarkerId('next'),
              position: _nextLocation!,
              infoWindow: const InfoWindow(title: 'Dimoni'),
              icon: _nextLocationIcon,
            ),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton,
    );
  }

  Progress? _getActualProgress(FireBaseProvider fireBaseProvider) {
    final actualUserUID = FirebaseAuth.instance.currentUser!.uid;
    final actualUser =
        fireBaseProvider.usersProvider.getUserById(actualUserUID);
    final Progress? progress =
        fireBaseProvider.progressProvider.progressMap[actualUser];

    return progress;
  }

  Gimcama? _getActualGimcana(FireBaseProvider fireBaseProvider) {
    final gimcanaId = fireBaseProvider.progressProvider.gimcanaId;

    if (gimcanaId == null) {
      return null;
    }

    final gimcana = fireBaseProvider.gimcanaProvider.getGimcanaById(gimcanaId);

    return gimcana;
  }

  void _getNext() {
    final fireBaseProvider =
        Provider.of<FireBaseProvider>(context, listen: false);
    final progress = _getActualProgress(fireBaseProvider);

    if (progress == null) {
      final firstUbi = _getActualGimcana(fireBaseProvider)?.ubications.first;
      _nextLocation = firstUbi?.getLatLng();
      _nextDimoni = firstUbi?.dimoni;
      return;
    }

    final founds = progress.discovers;
    final locations = progress.gimcamana.ubications;

    for (var ubic in locations) {
      if (!founds.any((element) => element.dimoni.id == ubic.dimoni.id)) {
        _nextLocation = ubic.getLatLng();
        _nextDimoni = ubic.dimoni;
        return;
      }
    }

    _nextLocation = null;
  }

  _locationRequest() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      locationServiceEnabled = serviceEnabled;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      hasLocationPermission = permissionGranted != PermissionStatus.granted;
    }

    if (hasLocationPermission && locationServiceEnabled) {
      _locationSubscription =
          location.onLocationChanged.listen(_onLocationChanged);
    }
  }

  void _onLocationChanged(LocationData locationData) {
    _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

    if (_nextLocation != null) {
      double distance = _calculateDistance(_currentLocation!, _nextLocation!);

      if (distance < 50) {
        _floatingActionButton = FloatingActionButton(
          elevation: 10,
          onPressed: () {
            _showDialog(context);
          },
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          child: const Icon(Icons.check),
        );
      } else {
        _floatingActionButton = null;
      }
    }
    setState(() {});
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<DropdownMenuItem<String>> dimonis = [];
        Provider.of<FireBaseProvider>(context, listen: false)
            .dimoniProvider
            .dimonis
            .forEach((element) {
          dimonis.add(DropdownMenuItem<String>(
            value: element.nom,
            child: Text(element.nom),
          ));
        });
        var selectedValue = 'Polisso2';
        return AlertDialog(
          title: const Text('Resposta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeInImage(
                    placeholder:
                        const AssetImage('assets/LoadingDimonis-unscreen.gif'),
                    image: NetworkImage(_nextDimoni!.image)),
                DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    selectedValue = newValue!;
                    setState(() {});
                  },
                  items: dimonis,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar resposta'),
              onPressed: () {
                _submit(selectedValue, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _submit(String resposta, BuildContext context) {
    final fireBaseProvider =
        Provider.of<FireBaseProvider>(context, listen: false);
    if (resposta.toLowerCase() == _nextDimoni!.nom.toLowerCase()) {
      fireBaseProvider.progressProvider.addDiscover(_nextDimoni!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resposta correcta'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resposta incorrecta'),
          backgroundColor: Colors.red,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  double _calculateDistance(LatLng from, LatLng to) {
    const int earthRadius = 6378137;
    double latDiff = _toRadians(to.latitude - from.latitude);
    double lngDiff = _toRadians(to.longitude - from.longitude);
    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(_toRadians(from.latitude)) *
            cos(_toRadians(to.latitude)) *
            sin(lngDiff / 2) *
            sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void setCustomMarker() async {
    _currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.5),
      'assets/circle.png',
    );
    _nextLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1),
      'assets/demon3.png',
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
