import 'dart:async';

import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapaPickerScreen extends StatefulWidget {
  const MapaPickerScreen({super.key});

  @override
  State<MapaPickerScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaPickerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;
  late Map<Dimoni, dynamic> dimoni;
  late Marker coordenadesDimoni = const Marker(markerId: MarkerId(''));
  late String _mapStyle;

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      _mapStyle = string;
    });
    final CameraPosition puntInicial = CameraPosition(
        target: getLatLng('39.76971,3.0123283'), zoom: 17, tilt: 50);

    dimoni = ModalRoute.of(context)!.settings.arguments as Map<Dimoni, dynamic>;

    if ('0' != dimoni.values.first['x'] && '0' != dimoni.values.first['y']) {
      coordenadesDimoni = Marker(
          markerId: const MarkerId('coordenadesDimoni'),
          infoWindow: InfoWindow(title: dimoni.keys.first.nom),
          position: LatLng(double.parse(dimoni.values.first['x']),
              double.parse(dimoni.values.first['y'])));
    }

    Set<Marker> markers = <Marker>{};
    markers.add(
      coordenadesDimoni,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mapTitle),
        actions: [
          IconButton(
            onPressed: () {
              tornarAlLlocInicial(puntInicial);
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
        initialCameraPosition: puntInicial,
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
          backgroundColor: Colors.red,
          onPressed: () {
            if ('0' != dimoni.values.first['x'] &&
                '0' != dimoni.values.first['y']) {
              Navigator.pop(context, dimoni);
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                headerAnimationLoop: false,
                animType: AnimType.topSlide,
                title: AppLocalizations.of(context)!.errorCoordinates,
                desc: AppLocalizations.of(context)!.coordinatesNotSelected,
                showCloseIcon: true,
                // btnCancelOnPress: () {},
                btnOkOnPress: () {},
              ).show();
            }
          },
          child: const Icon(Icons.save),
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

  void _addMarker(
      LatLng pos, Map<Dimoni, dynamic> dimoni, Marker coordenadesDimoni) {
    setState(() {
      coordenadesDimoni = Marker(
          markerId: const MarkerId('coordenadesDimoni'),
          infoWindow: InfoWindow(title: dimoni.keys.first.nom),
          position: pos);
    });
  }
}
