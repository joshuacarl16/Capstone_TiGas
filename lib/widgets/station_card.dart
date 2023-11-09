import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'dart:async';

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
                borderRadius: BorderRadius.circular(2.2 * unitWidthValue),
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
                    child: AutoScrollingGasTypes(
                      unitHeightValue: unitHeightValue,
                      unitWidthValue: unitWidthValue,
                      gasTypes: gasTypes,
                      gasTypeInfo: gasTypeInfo,
                    ),
                  ),
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

  List<Widget> _buildServicesIcons(
      double unitWidthValue, double unitHeightValue) {
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
      margin: EdgeInsets.symmetric(horizontal: 1.5 * unitHeightValue),
      height: 4 * unitHeightValue,
      width: 0.2 * unitHeightValue,
      color: Colors.grey,
    );
  }
}

class AutoScrollingGasTypes extends StatefulWidget {
  final double unitHeightValue;
  final double unitWidthValue;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;

  AutoScrollingGasTypes({
    Key? key,
    required this.unitHeightValue,
    required this.unitWidthValue,
    required this.gasTypes,
    required this.gasTypeInfo,
  }) : super(key: key);

  @override
  _AutoScrollingGasTypesState createState() => _AutoScrollingGasTypesState();
}

class _AutoScrollingGasTypesState extends State<AutoScrollingGasTypes> {
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => startScrolling());
  }

  void startScrolling() {
    const scrollDuration =
        Duration(seconds: 30); // Adjust scrolling speed as needed
    double scrollAmountPerTick =
        1.0; // Adjust this to control the scroll amount

    _scrollTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      _scrollPosition += scrollAmountPerTick;

      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _scrollPosition = 0; // Reset scroll position if we reached the end
        _scrollController.jumpTo(_scrollPosition);
      } else {
        _scrollController.animateTo(
          _scrollPosition,
          duration: Duration(milliseconds: 20),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _buildScrollingList(),
      ),
    );
  }

  List<Widget> _buildScrollingList() {
    List<String> extendedGasTypes = List.from(widget.gasTypes)
      ..addAll(widget.gasTypes)
      ..addAll(widget.gasTypes)
      ..addAll(widget.gasTypes);

    return List<Widget>.generate(extendedGasTypes.length * 2 - 1, (index) {
      if (index % 2 == 0) {
        String type = extendedGasTypes[index ~/ 2];
        return _buildGasTypeInfo(type, widget.gasTypeInfo[type]!,
            widget.unitHeightValue, widget.unitWidthValue);
      } else {
        return _buildDivider(widget.unitHeightValue);
      }
    });
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
}
//Cleanup