import 'dart:async';

import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationData>? _locationSubscription;

  LatLng? _nextDemon;
  LocationData? _currentLocation;
  bool hasLocationPermission = true;
  bool locationServiceEnabled = true;

  BitmapDescriptor _currentLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    locationRequest();
    setCustomMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context);

    if (playing.currentGimcana == null) {
      return const Center(
        child: Text('No hi ha cap gimcana seleccionada'),
      );
    }

    if (!hasLocationPermission) {
      return const Center(
        child: Text('No tens permisos per accedir a la localització'),
      );
    }

    if (!locationServiceEnabled) {
      return const Center(
        child: Text('No tens el servei de localització activat'),
      );
    }

    if (_currentLocation == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {
        Marker(
          markerId: const MarkerId('current'),
          position: _currentLocation != null
              ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
              : const LatLng(0, 0),
          infoWindow: const InfoWindow(title: 'Tu'),
          icon: _currentLocationIcon,
        ),
      },
    );
  }

  locationRequest() async {
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
      _listenLocation(location);
    }
  }

  void _listenLocation(Location location) {
    _locationSubscription = location.onLocationChanged.listen(_onLocationChanged);
  }

  void _onLocationChanged(LocationData locationData) {
    setState(() {
      _currentLocation = locationData;
    });
  }

  void setCustomMarker() async {
    _currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/circle.png',
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
