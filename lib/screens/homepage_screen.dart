// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tigas_application/models/station_list.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/widgets/station_card.dart';
import 'package:tigas_application/widgets/station_info.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class HomePage extends StatefulWidget {
  final int selectedTab;

  HomePage({super.key, required this.selectedTab});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> services = ['Air', 'Water', 'Oil', 'Restroom'];
  List<bool> serviceSelections = List<bool>.filled(4, false);
  final _places =
      GoogleMapsPlaces(apiKey: "AIzaSyDDGzL8DvSecRgC6cZIyU1WpeS-MU2Xzrw");

  void _filterServices() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Services'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                children: services.asMap().entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.value),
                    value: serviceSelections[entry.key],
                    onChanged: (value) {
                      setState(() {
                        serviceSelections[entry.key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyDDGzL8DvSecRgC6cZIyU1WpeS-MU2Xzrw",
    );
    displayPrediction(p, _places);
  }

  Future<Null> displayPrediction(
      Prediction? p, GoogleMapsPlaces? places) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places!.getDetailsByPlaceId(p.placeId!);

      var placeId = p.placeId;
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;

      print(lat);
      print(lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;

    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 20 * unitHeightValue,
            automaticallyImplyLeading: false,
            floating: false,
            elevation: 0,
            backgroundColor: Color(0xFF609966),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              background: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2 * unitHeightValue),
                    child: TextField(
                      onTap: _handlePressButton,
                      decoration: InputDecoration(
                          labelText: 'Current Location',
                          filled: true,
                          fillColor: Colors.grey[300]),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4 * unitWidthValue),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gasoline Station',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'station1',
                                child: Text('Shell'),
                              ),
                              DropdownMenuItem(
                                value: 'station2',
                                child: Text('Petron'),
                              ),
                              DropdownMenuItem(
                                value: 'station3',
                                child: Text('Caltex'),
                              ),
                              DropdownMenuItem(
                                value: 'station4',
                                child: Text('Seaoil'),
                              ),
                              DropdownMenuItem(
                                value: 'station5',
                                child: Text('Total'),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(width: 2 * unitWidthValue),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gas Type',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'type1',
                                child: Text('Regular'),
                              ),
                              DropdownMenuItem(
                                value: 'type2',
                                child: Text('Diesel'),
                              ),
                              DropdownMenuItem(
                                value: 'type3',
                                child: Text('Premium'),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(width: 2 * unitWidthValue),
                        IconButton(
                            onPressed: _filterServices,
                            icon: FaIcon(
                              FontAwesomeIcons.filter,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF609966),
              Color(0xFF175124),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: stations.length,
          itemBuilder: (context, index) {
            Station station = stations[index];
            return ListTile(
              title: StationCard(
                imagePath: station.imagePath,
                brand: station.brand,
                address: station.address,
                distance: station.distance,
                gasTypes: station.gasTypes,
                gasTypeInfo: station.gasTypeInfo,
                services: station.services,
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2 * unitHeightValue),
                          topRight: Radius.circular(2 * unitHeightValue),
                        ),
                        child: Container(
                            height: 55 * unitHeightValue,
                            width: 100 * unitWidthValue,
                            child: StationInfo()),
                      );
                    });
              },
            );
          },
        ),
      ),
    ));
  }
}