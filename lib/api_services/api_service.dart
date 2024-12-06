import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_map/api_services/models/location_from_cordinate.dart';
import 'package:http/http.dart' as http;
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
      throw Exception("Error fetching location");
    }
  }
}