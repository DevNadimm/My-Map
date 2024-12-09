import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/constant.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen(
      {super.key,
      required this.initialLatLng,
      required this.destinationLatLng});

  final LatLng initialLatLng;
  final LatLng destinationLatLng;

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  Completer<GoogleMapController> googleMapController = Completer();

  Set<Marker> markers = {};
  Set<Polyline> polyline = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();

    markers.add(
      Marker(
          markerId: const MarkerId('origin'),
          position: widget.initialLatLng,
          icon: BitmapDescriptor.defaultMarker),
    );
    markers.add(
      Marker(
          markerId: const MarkerId('destination'),
          position: widget.destinationLatLng,
          icon: BitmapDescriptor.defaultMarker),
    );

    _polyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Directions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.initialLatLng.latitude, widget.initialLatLng.longitude),
            zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
        markers: markers,
        polylines: polyline,
      ),
    );
  }

  void _polyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constant.apiKey,
      request: PolylineRequest(
        origin: PointLatLng(
            widget.initialLatLng.latitude, widget.initialLatLng.longitude),
        destination: PointLatLng(widget.destinationLatLng.latitude,
            widget.destinationLatLng.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    polyline.add(
      Polyline(
        polylineId: const PolylineId("Polyline"),
        color: Colors.blue,
        width: 6,
        points: polylineCoordinates,
      ),
    );
    setState(() {});
  }
}
