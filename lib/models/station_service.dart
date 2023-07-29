import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/url_manager.dart';

class StationService {
  final urlManager = UrlManager();

  Future<List<Station>> getStations() async {
    String url = await urlManager.getValidBaseUrl();

    try {
      final response = await http.get(Uri.parse('$url/stations/'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Station.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      throw Exception('Failed to load stations');
    }
  }
}
