import 'dart:async';

import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPickerScreen extends StatefulWidget {
  const MapaPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapaPickerScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaPickerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;
  late Map<Dimoni, dynamic> dimoni;
  late Marker coordenadesDimoni = Marker(markerId: const MarkerId(''));
  late String _mapStyle;

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      _mapStyle = string;
    });
    final CameraPosition _puntInicial = CameraPosition(
        target: getLatLng('39.76971,3.0123283'), zoom: 17, tilt: 50);

    dimoni = ModalRoute.of(context)!.settings.arguments as Map<Dimoni, dynamic>;

    if ('0' != dimoni.values.first['x'] && '0' != dimoni.values.first['y']) {
       coordenadesDimoni = Marker(
          markerId: const MarkerId('coordenadesDimoni'),
          infoWindow: InfoWindow(title: dimoni.keys.first.nom),
          position: LatLng(double.parse(dimoni.values.first['x']),
              double.parse(dimoni.values.first['y'])));
    }

    Set<Marker> markers = new Set<Marker>();
    markers.add(
      coordenadesDimoni,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () {
              tornarAlLlocInicial(_puntInicial);
            },
            icon: const Icon(Icons.location_pin),
          ),
          IconButton(
            onPressed: () {
              changeMapType();
            },
            icon: const Icon(Icons.layers),
          )
        ],
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: _currentMapType,
        markers: markers,
        onTap: (LatLng coor) => {
          _addMarker(coor, dimoni, coordenadesDimoni),
          dimoni.values.first['x'] = coor.latitude.toString(),
          dimoni.values.first['y'] = coor.longitude.toString(),
          },
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
          mapController.setMapStyle(_mapStyle);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: () {
            if ('0' != dimoni.values.first['x'] &&
                '0' != dimoni.values.first['y']) {
              Navigator.pop(context, dimoni);
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: const Icon(Icons.error_outline_outlined),
                    title: const Text('ERROR COORDENADES'),
                    content:
                        const Text('No s\'han seleccionat les coordenades'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> tornarAlLlocInicial(CameraPosition puntInicial) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(puntInicial));
  }

  void changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  LatLng getLatLng(String coordenades) {
    final latLng = coordenades.split(',');
    final latitude = double.parse(latLng[0]);
    final longitude = double.parse(latLng[1]);

    return LatLng(latitude, longitude);
  }

  void _addMarker(LatLng pos, Map<Dimoni, dynamic> dimoni, Marker coordenadesDimoni) {
    setState(() {
      coordenadesDimoni = Marker(
          markerId: const MarkerId('coordenadesDimoni'),
          infoWindow: InfoWindow(title: dimoni.keys.first.nom),
          position: pos);
    });
  }
}
