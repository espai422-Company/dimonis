import 'dart:async';

import 'package:app_dimonis/models/dimoni.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPickerScreen extends StatefulWidget {
  const MapaPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapaPickerScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaPickerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.satellite;

  @override
  Widget build(BuildContext context) {
    final CameraPosition _puntInicial = CameraPosition(
        target: getLatLng('39.76971,3.0123283'), zoom: 17, tilt: 50);

    final Dimoni dimoni = ModalRoute.of(context)!.settings.arguments as Dimoni;

    Marker coordenadesDimoni = dimoni.x == '0'
        ? const Marker(markerId: MarkerId(''))
        : Marker(
            markerId: const MarkerId('dimoniMarker'),
            position: getLatLng('${dimoni.x},${dimoni.y}'));

    Set<Marker> markers = new Set<Marker>();
    markers.add(
      coordenadesDimoni,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: _currentMapType,
        markers: markers,
        onTap: (LatLng coor) => _addMarker(coor, dimoni, coordenadesDimoni),
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.save),
          onPressed: () {
            if (dimoni.x != '0') {
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

  void _addMarker(LatLng pos, Dimoni dimoni, Marker coordenadesDimoni) {
    setState(() {
      coordenadesDimoni = Marker(
          markerId: const MarkerId('coordenadesDimoni'),
          infoWindow: InfoWindow(title: dimoni.nom),
          position: pos);
      dimoni.x = pos.latitude.toString();
      dimoni.y = pos.longitude.toString();
    });
  }
}
