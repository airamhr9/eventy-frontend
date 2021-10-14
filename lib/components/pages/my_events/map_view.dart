import 'package:eventy_front/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPositionSelector extends StatefulWidget {
  const MapPositionSelector() : super();

  @override
  _MapPositionSelectorState createState() => _MapPositionSelectorState();
}

class _MapPositionSelectorState extends State<MapPositionSelector> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng selectedLocation = LatLng(37.42796133580664, 1.085749655962);

  static final initialPos = CameraPosition(
    target: LatLng(37.42796133580664, 1.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar ubicación"),
        automaticallyImplyLeading: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialPos,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          LocationService.determinePosition()
              .then((value) => goToUserPos(value));
        },
        onTap: _onMapTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, label: Text("Seleccionar ubicación")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _onMapTapped(LatLng location) {
    print(location);
    setState(() {
      selectedLocation = location;
    });
  }

  Future<void> goToUserPos(LatLng coords) async {
    final newPos = CameraPosition(
      target: coords,
      zoom: 15,
    );
    setState(() {
      selectedLocation = coords;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
    print("hi");
  }
}
