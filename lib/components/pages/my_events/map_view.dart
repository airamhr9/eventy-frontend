import 'package:eventy_front/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class MapPositionSelector extends StatefulWidget {
  const MapPositionSelector() : super();

  @override
  _MapPositionSelectorState createState() => _MapPositionSelectorState();
}

class _MapPositionSelectorState extends State<MapPositionSelector> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng selectedLocation = LatLng(37.42796133580664, 1.085749655962);
  List<Marker> myMarker = [];
  late final initialPos;
  late String _mapStyle;

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    initialPos = CameraPosition(
      target: selectedLocation,
      zoom: 14.4746,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar ubicación"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
        child: GoogleMap(
          markers: Set.from(myMarker),
          mapType: MapType.normal,
          initialCameraPosition: initialPos,
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(_mapStyle);
            _controller.complete(controller);
            LocationService.determinePosition()
                .then((value) => goToUserPos(value));
          },
          onTap: _onMapTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.pop(context, selectedLocation);
          },
          label: Text("Seleccionar ubicación")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _onMapTapped(LatLng location) {
    print(location);
    setState(() {
      selectedLocation = location;
      myMarker = [];
      myMarker.add(
          Marker(markerId: MarkerId(location.toString()), position: location));
    });
  }

  Future<void> goToUserPos(LatLng coords) async {
    final newPos = CameraPosition(
      target: coords,
      zoom: 15,
    );
    setState(() {
      selectedLocation = coords;
      myMarker = [];
      myMarker
          .add(Marker(markerId: MarkerId(coords.toString()), position: coords));
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
    print("hi");
  }
}
