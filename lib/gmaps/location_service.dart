import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/models/user_location.dart';

class LocationService {
  final String key = 'AIzaSyCvx_bpq17DFPNuW9yNU4EvAo_oXFybnfo';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    print(results);

    return results;
  }

  Future<List<Map<String, dynamic>>> getGasStations() async {
    double lat = 10.3156992;
    double lng = 123.88543660000005;
    LatLng center = LatLng(lat, lng);
    double radius = 15.0;

    List<Map<String, dynamic>> gasStations = [];

    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${center.latitude},${center.longitude}&radius=${radius * 1000}&type=gas_station&key=$key';
    int stationCount = 0;
    const int maxStations = 30; // number of stations to fetch

    do {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load gas stations. HTTP status: ${response.statusCode}');
      }

      var json = convert.jsonDecode(response.body);
      var status = json['status'];
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        throw Exception('Google Places API error: $status');
      }

      var results = json['results'] as List<dynamic>;
      for (var result in results) {
        var geometry = result['geometry'];
        var location = geometry['location'];
        LatLng latLng = LatLng(location['lat'], location['lng']);

        gasStations.add({
          'name': result['name'],
          'location': latLng,
          'place_id': result['place_id'],
        });

        stationCount += 1;

        if (stationCount >= maxStations) {
          break;
        }
      }

      if (json.containsKey('next_page_token') && stationCount < maxStations) {
        await Future.delayed(Duration(seconds: 2));
        url =
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=${json['next_page_token']}&key=$key';
      } else {
        url = '';
      }
    } while (url.isNotEmpty && stationCount < maxStations);

    return gasStations;
  }

  Future<double> calculateDistanceToStation(Station station) async {
    double? userLat = UserLocation().latitude;
    double? userLng = UserLocation().longitude;

    if (userLat == null || userLng == null) {
      return Future.error('No location selected');
    }
    double distanceInMeters = Geolocator.distanceBetween(
        userLat, userLng, station.latitude, station.longitude);

    double distanceInKilometers = distanceInMeters / 1000;

    return distanceInKilometers;
  }

  Future<Station> getGasStation(String stationId) async {
    String url = "http://192.168.1.10:8000/stations/$stationId";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load station. HTTP status: ${response.statusCode}');
    }

    var json = convert.jsonDecode(response.body);

    Station station = Station(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: '',
      place_id: '',
      updated: DateTime.now(),
    );

    return station;
  }
}
