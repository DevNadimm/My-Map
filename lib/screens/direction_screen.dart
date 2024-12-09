import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/api_services/api_service.dart';
import 'package:my_map/api_services/models/place_autocomplete_model%20.dart';
import 'package:my_map/api_services/models/place_to_coordinates_model.dart';
import 'package:my_map/constant.dart';
import 'package:my_map/screens/polyline_screen.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  final TextEditingController initialLEditingController =
      TextEditingController();
  final TextEditingController destinationLEditingController =
      TextEditingController();

  PlaceAutocompleteModel? placeAutocompleteModel;
  PlaceToCoordinatesModel? placeToCoordinatesModel;

  LatLng? startingPoint;
  LatLng? destinationPoint;

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderSide: const BorderSide(width: 2, color: primaryColor),
    borderRadius: BorderRadius.circular(10),
  );

  bool isLoading = false;
  String activeField = '';

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        placeAutocompleteModel = null;
      });
      return;
    }

    try {
      setState(() => isLoading = true);
      final result = await ApiService().fetchPlaceSuggestions(query);
      setState(() => placeAutocompleteModel = result);
    } catch (e) {
      setState(() => placeAutocompleteModel = null);
    } finally {
      setState(() => isLoading = false);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: initialLEditingController,
                      decoration: InputDecoration(
                        label: const Text(
                          'Starting Point',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        border: borderStyle,
                        enabledBorder: borderStyle,
                        disabledBorder: borderStyle,
                        focusedBorder: borderStyle,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: initialLEditingController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_sharp),
                                onPressed: () {
                                  initialLEditingController.clear();
                                  setState(() => placeAutocompleteModel = null);
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        activeField = 'start';
                        fetchSuggestions(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: destinationLEditingController,
                decoration: InputDecoration(
                  label: const Text(
                    'Destination Point',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  border: borderStyle,
                  enabledBorder: borderStyle,
                  disabledBorder: borderStyle,
                  focusedBorder: borderStyle,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: destinationLEditingController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_sharp),
                          onPressed: () {
                            destinationLEditingController.clear();
                            setState(() => placeAutocompleteModel = null);
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  activeField = 'destination';
                  fetchSuggestions(value);
                },
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
              if (!isLoading &&
                  placeAutocompleteModel != null &&
                  placeAutocompleteModel!.predictions != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: placeAutocompleteModel!.predictions!.length,
                  itemBuilder: (context, index) {
                    final prediction =
                        placeAutocompleteModel!.predictions![index];
                    return ListTile(
                      onTap: () async {
                        if (activeField == 'start') {
                          initialLEditingController.text =
                              prediction.description!;
                        } else if (activeField == 'destination') {
                          destinationLEditingController.text =
                              prediction.description!;
                        }

                        try {
                          final result = await ApiService()
                              .fetchCoordinatesByPlaceId(prediction.placeId!);
                          setState(() => placeToCoordinatesModel = result);
                          final lat = placeToCoordinatesModel
                                  ?.result?.geometry?.location?.lat ??
                              0.0;
                          final lng = placeToCoordinatesModel
                                  ?.result?.geometry?.location?.lng ??
                              0.0;
                          if (activeField == 'start') {
                            startingPoint = LatLng(lat, lng);
                          } else if (activeField == 'destination') {
                            destinationPoint = LatLng(lat, lng);
                          }
                        } catch (e) {
                          // Handle error gracefully
                        }
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(prediction.description ?? 'N/A'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (startingPoint != null && destinationPoint != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PolylineScreen(
                              initialLatLng: startingPoint!,
                              destinationLatLng: destinationPoint!,
                            );
                          },
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'View Destinations',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
