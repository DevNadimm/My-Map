import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_map/api_services/models/get_places_model.dart';
import 'package:my_map/api_services/models/location_from_cordinate.dart';
import 'package:http/http.dart' as http;
import 'package:my_map/api_services/models/place_id_to_coordinates.dart';
import 'package:my_map/constant.dart';

class ApiService {
  Future<LocationFromCordinate> getLocation (double lat, double lng) async{
    final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if(response.statusCode == 200){

      final decodedData = jsonDecode(response.body);
      debugPrint("URL: $uri \nSTATUS CODE: ${response.statusCode} \nBODY: $decodedData");
      return LocationFromCordinate.fromJson(decodedData);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<GetPlacesModel> getPlaces (String locationName) async{
    final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if(response.statusCode == 200){

      final decodedData = jsonDecode(response.body);
      debugPrint("URL: $uri \nSTATUS CODE: ${response.statusCode} \nBODY: $decodedData");
      return GetPlacesModel.fromJson(decodedData);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<PlaceIdToCoordinates> getCordinateFromPlaceId (String placeId) async{
    final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Constant.apiKey}');
    final response = await http.get(uri);

    if(response.statusCode == 200){

      final decodedData = jsonDecode(response.body);
      debugPrint("URL: $uri \nSTATUS CODE: ${response.statusCode} \nBODY: $decodedData");
      return PlaceIdToCoordinates.fromJson(decodedData);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}