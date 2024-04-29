// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/screens/set_location.dart';
import 'package:tigas_application/styles/styles.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';
import 'package:tigas_application/widgets/station_card.dart';
import 'package:tigas_application/widgets/station_info.dart';

class HomePage extends StatefulWidget {
  final int selectedTab;
  final ScrollController scrollController;
  const HomePage({
    Key? key,
    required this.selectedTab,
    required this.scrollController,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController currentLocController = TextEditingController();
  List<Station> station = [];
  List<String>? gasTypesForSelectedBrand;
  String? location;
  String? selectedStation;
  List<String> services = ['Air', 'Water', 'Oil', 'Restroom'];
  List<bool> serviceSelections = List<bool>.filled(4, false);
  bool sortByGasPrice = false;
  bool sortByServices = false;
  String? selectedGasType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Loading Stations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );

      Provider.of<StationProvider>(context, listen: false)
          .fetchStations()
          .then((_) => Navigator.pop(
              context)) // close the dialog after fetchStations completes
          .catchError((error) {
        // Handle any errors here
        Navigator.pop(context); // close the dialog
      });
    });
  }

  double? getSelectedGasPrice(Map<String, String>? gasTypeInfo) {
    if (gasTypeInfo == null || !gasTypeInfo.containsKey(selectedGasType)) {
      return null;
    }

    return double.tryParse(gasTypeInfo[selectedGasType] ?? '') ??
        double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;

    return Scaffold(
        body: NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 25 * unitHeightValue,
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: currentLocController,
                            onTap: () async {
                              final selectedLocation = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => SetLocationScreen()),
                                  ));
                              if (selectedLocation != null) {
                                setState(() {
                                  location = selectedLocation;
                                  currentLocController.text = selectedLocation;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Set Location',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                          ),
                        ),
                        SizedBox(width: 2 * unitWidthValue),
                        FloatingActionButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          backgroundColor: Colors.grey[300],
                          onPressed: _filterServices,
                          child: FaIcon(
                            FontAwesomeIcons.filterCircleXmark,
                            color:
                                sortByServices ? Colors.red : Colors.green[400],
                          ),
                        )
                      ],
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
                              labelText: 'Gas Brand',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: null,
                                child: Text('Show All'),
                              ),
                              DropdownMenuItem(
                                value: 'Shell',
                                child: Text('Shell'),
                              ),
                              DropdownMenuItem(
                                value: 'Petron',
                                child: Text('Petron'),
                              ),
                              DropdownMenuItem(
                                value: 'Caltex',
                                child: Text('Caltex'),
                              ),
                              DropdownMenuItem(
                                value: 'Jetti',
                                child: Text('Jetti'),
                              ),
                              DropdownMenuItem(
                                value: 'Seaoil',
                                child: Text('Seaoil'),
                              ),
                              DropdownMenuItem(
                                value: 'Total',
                                child: Text('Total'),
                              ),
                              DropdownMenuItem(
                                value: 'Phoenix',
                                child: Text('Phoenix'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedStation = value;
                                selectedGasType =
                                    null; // Reset selected gas type when gas brand changes
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 2 * unitWidthValue),
                        Expanded(
                          child: Consumer<StationProvider>(
                              builder: (context, stationProvider, child) {
                            var allGasTypes = stationProvider.stations
                                .where((station) =>
                                    station.name ==
                                    selectedStation) //kani ako gichange
                                .map((station) => station.gasTypes)
                                .expand((i) => i ?? [])
                                .toSet()
                                .toList();
                            if (selectedStation != null &&
                                !allGasTypes.contains(selectedGasType)) {
                              selectedGasType = null;
                            } else {
                              gasTypesForSelectedBrand = null;
                            }

                            return DropdownButtonFormField<String>(
                              // itemHeight: null,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Gas Type',
                                filled: true,
                                fillColor: Colors.grey[300],
                              ),
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('Show All',
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ]..addAll(
                                  allGasTypes.map(
                                    //mao ni ako gichange

                                    (gasType) => DropdownMenuItem<String>(
                                      value: gasType,
                                      child: Text(
                                        gasType,
                                      ),
                                    ),
                                  ),
                                ),
                              onChanged: (value) {
                                setState(() {
                                  selectedGasType = value;
                                });
                              },
                              value: selectedGasType,
                            );
                          }),
                        ),
                        SizedBox(width: 2 * unitWidthValue),
                        FloatingActionButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          backgroundColor: Colors.grey[300],
                          onPressed: () {
                            setState(() {
                              sortByGasPrice = !sortByGasPrice;
                              if (sortByGasPrice == true) {
                                showSnackBar(context, 'Sorting by price',
                                    Duration(milliseconds: 500));
                              } else {
                                showSnackBar(context, 'Sorting by distance',
                                    Duration(milliseconds: 500));
                              }
                            });
                          },
                          child: FaIcon(
                            sortByGasPrice
                                ? FontAwesomeIcons.dollarSign
                                : FontAwesomeIcons.locationArrow,
                            color: sortByGasPrice
                                ? Colors.green[400]
                                : Colors.blue,
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
        decoration: getGradientDecoration(),
        child: Consumer<StationProvider>(
            builder: (context, stationProvider, child) {
          List<Station> filteredStations = stationProvider.stations
              .where((station) =>
                  (selectedStation == null ||
                      station.name.contains(selectedStation ?? '')) &&
                  (selectedGasType == null ||
                      station.gasTypes!.contains(selectedGasType)) &&
                  serviceSelections.asMap().entries.every((entry) {
                    return !entry.value ||
                        station.services!.contains(services[entry.key]);
                  }))
              .toList();

          filteredStations.sort((a, b) {
            if (sortByGasPrice) {
              var priceA = getSelectedGasPrice(a.gasTypeInfo);
              var priceB = getSelectedGasPrice(b.gasTypeInfo);

              if (priceA == null || priceB == null) {
                return 0;
              }
              return priceA.compareTo(priceB);
            }

            var distanceA = stationProvider.getDistanceToStation(a);
            var distanceB = stationProvider.getDistanceToStation(b);

            if (distanceA == null || distanceB == null) {
              return 0; // or whatever value makes sense in your context
            }

            return distanceA.compareTo(distanceB);
          });
          return RefreshIndicator(
            onRefresh: () =>
                Provider.of<StationProvider>(context, listen: false)
                    .fetchStations(),
            child: ListView.builder(
              itemCount: filteredStations.length,
              itemBuilder: (context, index) {
                Station station = filteredStations[index];
                return ListTile(
                  title: StationCard(
                    imagePath: station.imagePath.toString(),
                    brand: station.name,
                    address: station.address,
                    distance: station.distance.toString(),
                    gasTypes: station.gasTypes ?? [],
                    gasTypeInfo: station.gasTypeInfo!,
                    services: station.services ?? [],
                    station: station,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: 100 * unitWidthValue,
                                child: StationInfo(
                                  station: station,
                                  gasTypeInfo: station.gasTypeInfo ?? {},
                                  gasTypes: station.gasTypes ?? [],
                                  services: station.services ?? [],
                                )),
                          );
                        });
                  },
                );
              },
            ),
          );
        }),
      ),
    ));
  }

  void _filterServices() {
    List<bool> tempSelections = List.from(serviceSelections);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              title: const Text('Filter Services'),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: Column(
                  children: services.asMap().entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.value),
                      value: tempSelections[entry.key],
                      onChanged: (value) {
                        dialogSetState(() {
                          tempSelections[entry.key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      serviceSelections = tempSelections;
                      sortByServices =
                          serviceSelections.any((selection) => selection);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Apply'),
                )
              ],
            );
          },
        );
      },
    );
  }
}
