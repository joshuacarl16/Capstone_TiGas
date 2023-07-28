import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:http/http.dart' as http;

class StationProvider with ChangeNotifier {
  List<Station> _stations = [];

  List<Station> get stations => _stations;

  final LocationService _locationService = LocationService();
  Map<int, double> _distances = {};

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
  }

  Future<void> fetchStations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.10:8000/stations/'));
    // await http.get(Uri.parse('http://127.0.0.1:8000/stations/'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Station> fetchedStations = jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
      setStations(fetchedStations);
      await calculateDistances();
      notifyListeners();
    } else {
      throw Exception('Failed to load stations');
    }
  }
}
