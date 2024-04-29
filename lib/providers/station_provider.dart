import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:http/http.dart' as http;
import 'package:tigas_application/providers/url_manager.dart';

class StationProvider with ChangeNotifier {
  List<Station> _stations = [];

  List<Station> get stations => _stations;

  final LocationService _locationService = LocationService();
  Map<int, double> _distances = {};
  final UrlManager urlManager = UrlManager();

  void setStations(List<Station> stations) {
    _stations = stations;
    notifyListeners();
  }

  double? getDistanceToStation(Station station) {
    return _distances[station.id];
  }

  Future<void> calculateDistances() async {
    for (var station in _stations) {
      var distance = await _locationService.calculateDistanceToStation(station);
      _distances[station.id] = distance;
    }
    notifyListeners();
  }

  Future<void> fetchStations() async {
    try {
      String baseUrl = await urlManager.getValidBaseUrl();
      final response = await http
          .get(Uri.parse('$baseUrl/stations/'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        List<Station> fetchedStations = jsonResponse
            .map((item) => Station.fromMap(item as Map<String, dynamic>))
            .toList();
        setStations(fetchedStations);
        await calculateDistances();
        notifyListeners();
      } else {
        print('Failed to load stations');
      }
    } on TimeoutException {
      print('Request to stations API timed out');
    } catch (e) {
      print('Error when fetching stations: $e');
    }
  }
}
