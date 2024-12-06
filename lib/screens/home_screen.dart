import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/api_services/api_service.dart';
import 'package:my_map/api_services/models/location_from_cordinate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double defaultLat = 22.362297444618562;
  double defaultLng = 91.80943865329027;
  
  LocationFromCordinate locationFromCordinate = LocationFromCordinate();
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Map"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(defaultLat, defaultLng),
              zoom: 14.4746,
            ),
            onCameraMove: (CameraPosition position) {
              defaultLat = position.target.latitude;
              defaultLng = position.target.longitude;
              debugPrint("Latitude: ${position.target.latitude} Longitude: ${position.target.longitude}");
            },
            onCameraIdle: () {
              apiService.getLocation(defaultLat, defaultLng).then((value) {
                setState(() {
                  locationFromCordinate = value;
                });
              });
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Text(locationFromCordinate.results?[0].formattedAddress ??  'Loading...'),
      ),
    );
  }
}
