import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/api_services/api_service.dart';
import 'package:my_map/api_services/models/location_from_cordinate.dart';
import 'package:my_map/constant.dart';

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
        title: const Text(
          "My-Map",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(defaultLat, defaultLng),
              zoom: 14.4746,
            ),
          zoomControlsEnabled: false,
            onCameraMove: (CameraPosition position) {
              defaultLat = position.target.latitude;
              defaultLng = position.target.longitude;
              debugPrint(
                  "Latitude: ${position.target.latitude} Longitude: ${position.target.longitude}");
            },
            onCameraIdle: () async {
              final result =
                  await apiService.getLocation(defaultLat, defaultLng);
              locationFromCordinate = result;
              setState(() {});
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
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Text(
          locationFromCordinate.results?[0].formattedAddress ?? 'Loading...',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
