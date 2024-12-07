import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_map/api_services/models/get_places_model.dart';
import 'package:my_map/api_services/models/location_from_cordinate.dart';
import 'package:my_map/api_services/models/place_id_to_coordinates.dart';
import 'package:my_map/constant.dart';

class ApiService {
  Future<LocationFromCoordinate> fetchLocationByCoordinates(double latitude, double longitude) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return LocationFromCoordinate.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch location: ${response.statusCode}');
    }
  }

  Future<GetPlacesModel> fetchPlaceSuggestions(String query) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return GetPlacesModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch place suggestions: ${response.statusCode}');
    }
  }

  Future<PlaceIdToCoordinates> fetchCoordinatesByPlaceId(String placeId) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      debugPrint("Request URL: $uri");
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");
      return PlaceIdToCoordinates.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch coordinates: ${response.statusCode}');
    }
  }
}
