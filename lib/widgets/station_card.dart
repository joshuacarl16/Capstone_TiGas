import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:marquee/marquee.dart';

class StationCard extends StatelessWidget {
  final String imagePath;
  final String brand;
  final String address;
  final String distance;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;
  final List<String> services;
  final Station station;

  StationCard({
    Key? key,
    required this.imagePath,
    required this.brand,
    required this.address,
    required this.distance,
    required this.gasTypes,
    required this.gasTypeInfo,
    required this.services,
    required this.station,
  }) : super(key: key);

  final Map<String, FaIcon> servicesIcons = {
    "Air": FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
    "Water": FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
    "Oil": FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
    "Restroom": FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 3 * unitWidthValue, vertical: 1.5 * unitHeightValue),
      child: Material(
        elevation: 5,
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.2 * unitWidthValue),
        child: Stack(
          children: [
            Positioned(
              right: 3 * unitWidthValue,
              top: -2 * unitHeightValue,
              child: ClipRRect(
                child: Image.asset(
                  imagePath,
                  height: 16 * unitHeightValue,
                  width: 16 * unitWidthValue,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3 * unitWidthValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(right: 16 * unitWidthValue),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(brand,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 3 * unitHeightValue,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                address,
                                style: GoogleFonts.catamaran(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                    fontSize: 1.6 * unitHeightValue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: unitHeightValue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        _buildServicesIcons(unitWidthValue, unitHeightValue),
                  ),
                  SizedBox(height: unitHeightValue),
                  Center(
                      child: _buildGasTypes(unitHeightValue, unitWidthValue)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(2.2 * unitWidthValue),
                        bottomRight: Radius.circular(2.2 * unitWidthValue),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Provider.of<StationProvider>(context, listen: false)
                                      .getDistanceToStation(station) !=
                                  null
                              ? '${Provider.of<StationProvider>(context, listen: false).getDistanceToStation(station)!.toStringAsFixed(2)} km'
                              : '',
                          style: GoogleFonts.exo2(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
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
          children: List<Widget>.generate(gasTypes.length * 2 - 1, (index) {
            if (index % 2 == 0) {
              String type = gasTypes[index ~/ 2];
              return _buildGasTypeInfo(
                  type, gasTypeInfo[type]!, unitHeightValue, unitWidthValue);
            } else {
              return _buildDivider(unitHeightValue);
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

  Container _buildDivider(double unitHeightValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1 * unitHeightValue),
      height: 7 * unitHeightValue,
      child: VerticalDivider(
        color: Colors.black,
        indent: unitHeightValue,
        endIndent: unitHeightValue,
      ),
    );
  }

  List<Widget> _buildServicesIcons(
      double unitWidthValue, double unitHeightValue) {
    for (var serviceName in services) {
      if (!servicesIcons.containsKey(serviceName)) {}
    }

    return [
      for (var serviceName in services)
        if (servicesIcons.containsKey(serviceName)) ...[
          servicesIcons[serviceName]!,
          SizedBox(
            width: 5 * unitWidthValue,
          ),
        ]
    ];
  }
}
