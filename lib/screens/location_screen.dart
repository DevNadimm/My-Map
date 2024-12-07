import 'package:flutter/material.dart';
import 'package:my_map/api_services/api_service.dart';
import 'package:my_map/api_services/models/place_autocomplete_model .dart';
import 'package:my_map/api_services/models/place_to_coordinates_model.dart';
import 'package:my_map/constant.dart';
import 'package:my_map/location_permission_handler.dart';
import 'package:my_map/screens/home_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController searchController = TextEditingController();
  PlaceAutocompleteModel placeAutocompleteModel = PlaceAutocompleteModel();
  PlaceToCoordinatesModel placeToCoordinatesModel = PlaceToCoordinatesModel();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: primaryColor),
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Location",
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
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  label: const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  border: borderStyle,
                  errorBorder: borderStyle,
                  focusedBorder: borderStyle,
                  disabledBorder: borderStyle,
                  enabledBorder: borderStyle,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_sharp),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (String value) async {
                  final result = await ApiService().fetchPlaceSuggestions(value);
                  placeAutocompleteModel = result;
                  setState(() {});
                },
              ),
              searchController.text.isEmpty
                  ? const SizedBox(height: 16)
                  : const SizedBox(),
              Visibility(
                visible: searchController.text.isNotEmpty,
                child: ListView.builder(
                  itemCount: placeAutocompleteModel.predictions?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () async {
                        final result = await ApiService().fetchCoordinatesByPlaceId(placeAutocompleteModel.predictions![index].placeId!);
                        placeToCoordinatesModel = result;
                        final lat = placeToCoordinatesModel.result?.geometry?.location?.lat ?? 0.0;
                        final lng = placeToCoordinatesModel.result?.geometry?.location?.lng ?? 0.0;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScreen(lat: lat,lng: lng,);
                            },
                          ),
                        );
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              placeAutocompleteModel.predictions?[index].description ??
                                  'N/A',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: searchController.text.isEmpty,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      determinePosition().then(
                        (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen(lat: value.latitude,lng: value.longitude,);
                              },
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
