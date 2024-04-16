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
import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/rate_station.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/reviews_model.dart';
import '../screens/camera_screen.dart';

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
  final urlManager = UrlManager();

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
    String url = await urlManager.getValidBaseUrl();
    final response = await http.get(Uri.parse('$url/stations/'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<List<Review>> fetchReviews(int stationId) async {
    String url = await urlManager.getValidBaseUrl();
    final response =
        await http.get(Uri.parse('$url/stations/$stationId/reviews'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  showRatingDialog(BuildContext context, int stationId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: RateDialog(stationId: stationId),
        );
      },
    );
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
      child: RefreshIndicator(
        onRefresh: () async {
          await fetchReviews(widget.station.id);
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.station.name,
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(widget.station.address,
                        style: GoogleFonts.catamaran(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                  ),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => GMaps(
                                destination: widget.station.id.toString())),
                          ));
                    },
                    icon: FaIcon(FontAwesomeIcons.car),
                    label: Text('Get Route'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.green[700]),
                  ),
                  SizedBox(height: 10),
  	              ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(
                              selectedStation: widget.station,
                            ),
                          ),
                        );
                      },
                      icon: FaIcon(FontAwesomeIcons.cameraRetro),
                      label: Text('Update Price'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.green[700]),
                    ),
                  SizedBox(height: unitWidthValue * 6),
                  Center(
                      child: _buildGasTypes(unitHeightValue, unitWidthValue)),
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
                  SizedBox(height: unitHeightValue * 6),
                  ElevatedButton.icon(
                    onPressed: () {
                      showRatingDialog(context, widget.station.id);
                    },
                    icon: FaIcon(FontAwesomeIcons.comments),
                    label: Text('Review This Station'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.green[700]),
                  ),
                  SizedBox(height: unitHeightValue * 6),
                  FutureBuilder<List<Review>>(
                    future: fetchReviews(widget.station.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Review>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            Review? review = snapshot.data?[index];
                            DateTime created = tz.TZDateTime.from(
                                DateTime.parse(review?.created ?? ''),
                                tz.getLocation('Asia/Manila'));
                            return Card(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review?.reviewerName ?? '',
                                          style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              i < review!.rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: i < review.rating
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      review?.review.join(', ') ?? '',
                                      style: GoogleFonts.catamaran(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      review?.content ?? '',
                                      style: GoogleFonts.catamaran(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      DateFormat('yyyy-MM-dd - hh:mm a')
                                          .format(created),
                                      style: GoogleFonts.catamaran(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isStarred = !isStarred;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: isStarred ? Colors.red : Colors.transparent,
                            size: unitWidthValue * 8,
                          ),
                          FaIcon(
                            FontAwesomeIcons.heart,
                            color: isStarred ? Colors.red : Colors.grey,
                            size: unitWidthValue * 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
