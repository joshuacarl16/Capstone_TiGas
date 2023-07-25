import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:http/http.dart' as http;

class StationProvider with ChangeNotifier {
  List<Station> _stations = [];

  List<Station> get stations => _stations;

  void setStations(List<Station> stations) {
    _stations = stations;
    notifyListeners();
  }

  void addStation(Station station) {
    _stations.add(station);
    notifyListeners();
  }

  void removeStation(int id) {
    _stations.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> fetchStations() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/stations/'));
    // await http.get(Uri.parse('http://192.168.1.4:8000/stations/')); // used for external device
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Station> fetchedStations = jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
      setStations(fetchedStations);
      notifyListeners();
    } else {
      throw Exception('Failed to load stations');
    }
  }
}
