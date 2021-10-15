import 'package:eventy_front/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPositionSelector extends StatefulWidget {
  final LatLng eventPos;
  const MapPositionSelector(this.eventPos) : super();

  @override
  _MapPositionSelectorState createState() => _MapPositionSelectorState();
}

class _MapPositionSelectorState extends State<MapPositionSelector> {
  List<Marker> myMarker = [];
  late CameraPosition initialPos;

  @override
  initState() {
    super.initState();
    initialPos = CameraPosition(
      target: widget.eventPos,
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del evento"),
        automaticallyImplyLeading: true,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            myMarker.add(Marker(
                markerId: MarkerId(widget.eventPos.toString()),
                position: widget.eventPos));
          });
        },
        markers: Set.from(myMarker),
        mapType: MapType.normal,
        initialCameraPosition: initialPos,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
