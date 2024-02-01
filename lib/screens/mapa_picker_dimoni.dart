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
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;
  var x, y;

  @override
  Widget build(BuildContext context) {
    final CameraPosition _puntInicial = CameraPosition(target: getLatLng('39.76971,3.0123283'), zoom: 17, tilt: 50);

    final Map<String,String> dimoni = ModalRoute.of(context)!.settings.arguments as Map<String,String>;
    
    if (x == null){
      x = dimoni['x'];
      y = dimoni['y'];
      print(x);
    }

    Marker coordenadesDimoni = x == '0'
        ? const Marker(markerId: MarkerId(''))
        : Marker(
            markerId: const MarkerId('dimoniMarker'),
            position: getLatLng('${x},${y}'));

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
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: _currentMapType,
        markers: markers,
        onTap: (LatLng coor) => _addMarker(coor, coordenadesDimoni),
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
            if (x != '0') {
              Navigator.pop(context, {'x' : '$x', 'y' : '$y'} as Map<String,String>);
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

  void _addMarker(LatLng pos, Marker coordenadesDimoni) {
    setState(() {
      x = pos.latitude.toString();
      y = pos.longitude.toString();
    });
  }
}
