import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/api_services/api_service.dart';
import 'package:my_map/api_services/models/coordinates_to_place_model.dart';
import 'package:my_map/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.lat, required this.lng, });

  final double lat;
  final double lng;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double defaultLat = 22.362297444618562;
  double defaultLng = 91.80943865329027;

  CoordinatesToPlaceModel coordinatesToPlaceModel = CoordinatesToPlaceModel();
  ApiService apiService = ApiService();

  @override
  void initState() {
    defaultLat = widget.lat;
    defaultLng = widget.lng;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
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
              zoom: 15,
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
                  await apiService.fetchLocationByCoordinates(defaultLat, defaultLng);
              coordinatesToPlaceModel = result;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_pin,
              color: Colors.black54,
            ),
            Expanded(
              child: Text(
                coordinatesToPlaceModel.results?[0].formattedAddress ??
                    'Loading...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
