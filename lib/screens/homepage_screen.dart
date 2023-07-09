// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tigas_application/models/station_list.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/widgets/station_card.dart';
import 'package:tigas_application/widgets/station_info.dart';

class HomePage extends StatefulWidget {
  final int selectedTab;

  HomePage({super.key, required this.selectedTab});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                                child: Text('Gas Station 1'),
                              ),
                              DropdownMenuItem(
                                value: 'station2',
                                child: Text('Gas Station 2'),
                              ),
                              // Add more dropdown items as needed
                            ],
                            onChanged: (value) {
                              // Handle dropdown value change
                            },
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
                                child: Text('Gas Type 1'),
                              ),
                              DropdownMenuItem(
                                value: 'type2',
                                child: Text('Gas Type 2'),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
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
              Color(0xFF609966), // Start color
              Color(0xFF175124), // End color
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
