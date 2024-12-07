import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_map/api_services/models/place_autocomplete_model .dart';
import 'package:my_map/api_services/models/coordinates_to_place_model.dart';
import 'package:my_map/api_services/models/place_to_coordinates_model.dart';
import 'package:my_map/constant.dart';

class ApiService {
  Future<CoordinatesToPlaceModel> fetchLocationByCoordinates(double latitude, double longitude) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return CoordinatesToPlaceModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch location: ${response.statusCode}');
    }
  }

  Future<PlaceAutocompleteModel> fetchPlaceSuggestions(String query) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return PlaceAutocompleteModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch place suggestions: ${response.statusCode}');
    }
  }

  Future<PlaceToCoordinatesModel> fetchCoordinatesByPlaceId(String placeId) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return PlaceToCoordinatesModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch coordinates: ${response.statusCode}');
    }
  }
}
