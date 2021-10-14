import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<LatLng> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position geoPosition = await Geolocator.getCurrentPosition();

    return LatLng(geoPosition.latitude, geoPosition.longitude);
  }

  static Future<String> getAddressFromCoords(LatLng coords) async {
    var googleGeocoding = GoogleGeocoding("Your-Key");
    return googleGeocoding.geocoding
        .getReverse(LatLon(coords.latitude, coords.longitude))
        .toString();
  }
}
