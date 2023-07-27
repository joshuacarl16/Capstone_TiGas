// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:tigas_application/gmaps/google_map.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class StationInfo extends StatefulWidget {
  final Station station;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;
  final List<String> services;

  StationInfo({
    Key? key,
    required this.station,
    required this.gasTypes,
    required this.gasTypeInfo,
    required this.services,
  }) : super(key: key);

  @override
  _StationInfoState createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  bool isStarred = false;
  double? distanceToStation;

  @override
  void initState() {
    super.initState();
  }

  final Map<String, FaIcon> servicesIcons = {
    "Air": FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
    "Water": FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
    "Oil": FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
    "Restroom": FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
  };

  Future<List<Station>> fetchStations() async {
    final response =
        // await http.get(Uri.parse('http://127.0.0.1:8000/stations/'));
        await http.get(Uri.parse(
            'http://192.168.1.10:8000/stations/')); //used for external device
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;
    DateTime updated = tz.TZDateTime.from(
        widget.station.updated, tz.getLocation('Asia/Manila'));

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.station.name,
                    style: GoogleFonts.ubuntu(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                Text(widget.station.address,
                    style: GoogleFonts.catamaran(
                        fontWeight: FontWeight.w600, color: Colors.grey[600])),
                FutureBuilder<double>(
                  future: LocationService()
                      .calculateDistanceToStation(widget.station),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        '${snapshot.data?.toStringAsFixed(2)} km',
                        style: GoogleFonts.catamaran(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      );
                    }
                  },
                ),
                SizedBox(height: unitWidthValue * 6),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.car),
                  label: Text('Get Route'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.green[700]),
                ),
                SizedBox(height: unitWidthValue * 6),
                Center(child: _buildGasTypes(unitHeightValue, unitWidthValue)),
                SizedBox(height: unitWidthValue * 6),
                Center(
                  child: Text('Services Offered',
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: unitWidthValue * 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _buildServicesIcons(unitWidthValue, unitHeightValue),
                ),
                SizedBox(height: unitWidthValue * 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Last Updated: ${DateFormat('yyyy-MM-dd - hh:mm a').format(updated)}',
                      style: GoogleFonts.catamaran(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isStarred = !isStarred;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: isStarred ? Colors.yellow : Colors.transparent,
                    ),
                    FaIcon(
                      FontAwesomeIcons.star,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGasTypes(double unitHeightValue, double unitWidthValue) {
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              List<Widget>.generate(widget.gasTypes.length * 2 - 1, (index) {
            if (index % 2 == 0) {
              String type = widget.gasTypes[index ~/ 2];
              return _buildGasTypeInfo(type, widget.gasTypeInfo[type]!,
                  unitHeightValue, unitWidthValue);
            } else {
              return _buildDivider(unitHeightValue, unitWidthValue);
            }
          }),
        ),
      ),
    );
  }

  Column _buildGasTypeInfo(String type, String price, double unitHeightValue,
      double unitWidthValue) {
    return Column(
      children: [
        Text(
          type,
          style: GoogleFonts.catamaran(
            fontSize: 2 * unitHeightValue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 1.6 * unitHeightValue,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Container _buildDivider(double unitHeightValue, double unitWidthValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1 * unitHeightValue),
      height: 7 * unitHeightValue,
      width: 7 * unitWidthValue,
      child: VerticalDivider(
        color: Colors.black,
        indent: unitHeightValue,
        endIndent: unitHeightValue,
      ),
    );
  }

  List<Widget> _buildServicesIcons(
      double unitWidthValue, double unitHeightValue) {
    for (var serviceName in widget.services) {
      if (!servicesIcons.containsKey(serviceName)) {}
    }

    return [
      for (var serviceName in widget.services)
        if (servicesIcons.containsKey(serviceName)) ...[
          servicesIcons[serviceName]!,
          SizedBox(
            width: 5 * unitWidthValue,
          ),
        ]
    ];
  }
}
