import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tigas_application/models/station_model.dart';

class StationService {
  final String baseUrl = 'http://192.168.1.4:8000';

  Future<List<Station>> getStations() async {
    final response = await http.get(Uri.parse('$baseUrl/stations/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Station.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
}
