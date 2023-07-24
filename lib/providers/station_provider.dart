import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        await http.get(Uri.parse('http://192.168.1.4:8000/stations/'));
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

  // Future<void> fetchStations() async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.1.4:8000/stations/'));
  //   if (response.statusCode == 200) {
  //     List jsonResponse = jsonDecode(response.body);
  //     _stations = jsonResponse
  //         .map((item) => Station.fromMap(item as Map<String, dynamic>))
  //         .toList();
  //     notifyListeners();
  //   } else {
  //     throw Exception('Failed to load stations');
  //   }
  // }

  // Future<void> createStation(
  //     String imagePath,
  //     String brand,
  //     String address,
  //     double distance,
  //     List<String> gasTypes,
  //     Map<String, String> gasTypeInfo,
  //     List<String> services) {
  //   return http
  //       .post(
  //     Uri.parse('http://192.168.1.4:8000/stations/create/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'imagePath': imagePath,
  //       'brand': brand,
  //       'address': address,
  //       'distance': distance,
  //       'gasTypes': gasTypes,
  //       'gasTypeInfo': gasTypeInfo,
  //       'services': services,
  //     }),
  //   )
  //       .then((response) {
  //     if (response.statusCode == 200) {
  //       fetchStations();
  //     } else {
  //       throw Exception('Failed to create station');
  //     }
  //   });
  // }

  // Future<void> deleteStation(int id) {
  //   return http.delete(
  //     Uri.parse('http://192.168.1.4:8000/stations/$id/delete/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   ).then((response) {
  //     if (response.statusCode == 200) {
  //       fetchStations(); // refetch stations after one has been deleted
  //     } else {
  //       throw Exception('Failed to delete station');
  //     }
  //   });
  // }
}
