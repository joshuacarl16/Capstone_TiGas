import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/screens/camera_screen.dart';
import 'package:tigas_application/styles/styles.dart';

class StationSelector extends StatefulWidget {
  @override
  _StationSelectorState createState() => _StationSelectorState();
}

class _StationSelectorState extends State<StationSelector> {
  Future<List<Station>> fetchStations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.10:8000/stations/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Station> fetchedStations = jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
      return fetchedStations;
    } else {
      throw Exception('Failed to load stations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Station>>(
      future: fetchStations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: getGradientDecoration(),
            child: AlertDialog(
              title: Text('Loading...'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.red,
            child: AlertDialog(
              title: Text('Error'),
              content: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          List<Station> stations = snapshot.data!;
          return Container(
            decoration: getGradientDecoration(),
            child: AlertDialog(
              title: Text('Select a Station'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: ListTile(
                        title: Text(
                            '${stations[index].address} (${stations[index].name})'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                selectedStation: stations[
                                    index], // Pass the selected station to the camera screen
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
