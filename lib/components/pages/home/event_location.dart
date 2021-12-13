import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class EventLocation extends StatefulWidget {
  final LatLng eventPos;
  const EventLocation(this.eventPos) : super();

  @override
  _EventLocationState createState() => _EventLocationState();
}

class _EventLocationState extends State<EventLocation> {
  List<Marker> myMarker = [];
  late CameraPosition initialPos;
  late String _mapStyle;

  @override
  initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
        child: GoogleMap(
          onMapCreated: (controller) {
            controller.setMapStyle(_mapStyle);
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
