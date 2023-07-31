import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:http/http.dart' as http;
import 'package:tigas_application/providers/url_manager.dart';
import 'dart:convert';

import 'package:tigas_application/widgets/show_snackbar.dart';

class EditStation extends StatefulWidget {
  EditStation({Key? key}) : super(key: key);

  @override
  _EditStationState createState() => _EditStationState();
}

class _EditStationState extends State<EditStation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? imagePath, brand, address, gasTypes, gasTypeInfo;
  double? distance;
  double? latitude;
  double? longitude;
  List<Station> stations = [];
  int? id;
  Map<String, String> gasTypePrices = {};
  Station? currentStation;
  String? selectedAddress;
  String? selectedImagePath;
  List<String> selectedGasTypes = [];
  bool stationsLoaded = false;
  Map<String, TextEditingController> gasTypePriceControllers = {};
  final urlManager = UrlManager();

  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController gasTypesController = TextEditingController();
  final TextEditingController gasTypeInfoController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController gasTypePriceController = TextEditingController();

  List<String> imagePaths = [
    'assets/shell.png',
    'assets/caltex.png',
    'assets/petron.png',
    'assets/phoenix.png',
    'assets/total.png',
    'assets/seaoil.png',
    'assets/jetti.png',
    'assets/easygas.png'
  ];
  List<String> brands = [
    'Shell',
    'Caltex',
    'Petron',
    'Phoenix',
    'Total',
    'Seaoil'
  ];

  Map<String, List<String>> brandGasTypes = {
    'assets/shell.png': [
      'FuelSave Unleaded',
      'V-Power Gasoline',
      'FuelSave Diesel',
      'V-Power Diesel'
    ],
    'assets/caltex.png': ['Silver', 'Platinum', 'Diesel'],
    'assets/petron.png': [
      'Blaze 100 Euro 6',
      'XCS',
      'Xtra Advance',
      'Turbo Diesel',
      'Diesel Max'
    ],
    'assets/phoenix.png': ['Diesel', 'Super', 'Premium 95', 'Premium 98'],
    'assets/jetti.png': ['DieselMaster', 'Accelrate', 'JX Premium'],
    'assets/total.png': ['Excellium Unleaded', 'Excellium Diesel'],
    'assets/seaoil.png': [
      'Extreme 97',
      'Extreme 95',
      'Extreme U',
      'Extreme Diesel'
    ],
  };

  Map<String, bool> services = {
    'Air': false,
    'Water': false,
    'Oil': false,
    'Restroom': false,
  };

  Future<http.Response> updateStation(Station station) async {
    String url = await urlManager.getValidBaseUrl();
    Map<String, dynamic> requestBody = {
      'imagePath': selectedImagePath,
      'distance': double.tryParse(distanceController.text) ?? 0.0,
      'gasTypes': selectedGasTypes,
      'gasTypeInfo': gasTypePrices,
      'services': services.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
    };

    return http.patch(
      Uri.parse(
        '$url/stations/${station.id}/update/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<List<Station>> fetchAllStationsDetails() async {
    String url = await urlManager.getValidBaseUrl();
    final response = await http.get(Uri.parse('$url/stations/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      List<Station> stations =
          jsonResponse.map((dynamic item) => Station.fromMap(item)).toList();

      return stations;
    } else {
      throw Exception(
          'Failed to load stations. Status code: ${response.statusCode}. Response: ${response.body}');
    }
  }

  Future<http.Response> deleteStation(int id) async {
    String url = await urlManager.getValidBaseUrl();
    return http.delete(Uri.parse('$url/stations/$id/delete/'));
  }

  @override
  void dispose() {
    imagePathController.dispose();
    distanceController.dispose();
    gasTypesController.dispose();
    gasTypeInfoController.dispose();
    servicesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchAllStationsDetails().then((value) {
      setState(() {
        stations = value;
        stationsLoaded = true;
      });
    });
  }

  void onStationSelected(int id) {
    fetchAllStationsDetails();
  }

  Future<String?> _showServicesDialog() {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Services'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: services.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: services[key],
                      onChanged: (bool? value) {
                        setState(() {
                          services[key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(services.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .join(', '));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    itemHeight: null,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: 'Address'),
                    value: id,
                    items: stationsLoaded
                        ? stations.map((Station station) {
                            return DropdownMenuItem<int>(
                              value: station.id,
                              child: Text(station.address),
                            );
                          }).toList()
                        : [],
                    onChanged: (newValue) {
                      setState(() {
                        id = newValue;
                        currentStation = stations.firstWhere(
                          (station) => station.id == newValue,
                        );
                        selectedAddress = currentStation?.address;
                        addressController.text = selectedAddress ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an address';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Image'),
                    value: selectedImagePath,
                    items: imagePaths.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedImagePath = newValue;
                        selectedGasTypes = brandGasTypes[newValue ?? ''] ?? [];
                        gasTypesController.text = selectedGasTypes.join(', ');
                        gasTypePriceControllers = Map.fromIterable(
                          selectedGasTypes,
                          key: (gasType) => gasType,
                          value: (gasType) => TextEditingController(
                              text: gasTypePrices[gasType] ?? ''),
                        );
                      });
                      onStationSelected(id!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an image path';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: distanceController,
                    decoration: InputDecoration(labelText: 'Distance'),
                    onSaved: (value) {
                      distance =
                          value == '' ? distance : double.tryParse(value ?? '');
                    },
                    validator: (value) {
                      if (value != '' && double.tryParse(value!) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: gasTypesController,
                    decoration: InputDecoration(labelText: 'Gas Types'),
                    onSaved: (value) {
                      selectedGasTypes = value!.split(',');
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedImagePath = newValue;
                        selectedGasTypes = brandGasTypes[newValue] ?? [];
                        gasTypesController.text = selectedGasTypes.join(', ');
                      });
                      onStationSelected(id!);
                    },
                  ),
                  ...selectedGasTypes
                      .map(
                        (gasType) => TextFormField(
                          controller: gasTypePriceControllers[gasType],
                          decoration: InputDecoration(
                            hintText: 'Enter price for $gasType',
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              gasTypePrices[gasType] = newValue;
                            });
                          },
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter price for $gasType';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                        ),
                      )
                      .toList(),
                  TextFormField(
                    readOnly: true,
                    controller: servicesController,
                    decoration: InputDecoration(labelText: 'Services'),
                    onTap: () async {
                      final selectedServices = await _showServicesDialog();
                      if (selectedServices != null) {
                        servicesController.text = selectedServices;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (currentStation != null) {
                        // Call the API to update the station
                        final http.Response response =
                            await updateStation(currentStation!);
                        if (response.statusCode == 200) {
                          // If the server returns a 200 OK response,
                          // then parse the JSON.
                          showSnackBar(context, 'Station Updated Successfully');
                          List<Station> updatedStations =
                              await fetchAllStationsDetails();
                          setState(() {
                            stations = updatedStations;
                          });
                        } else {
                          // If the server returns an unexpected response,
                          // then throw an exception.
                          throw Exception('Failed to update station');
                        }
                      }
                    },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    itemHeight: null,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: 'Address to Delete'),
                    value: id,
                    items: stationsLoaded
                        ? stations.map((Station station) {
                            return DropdownMenuItem<int>(
                              value: station.id,
                              child: Text(station.address),
                            );
                          }).toList()
                        : [],
                    onChanged: (newValue) {
                      setState(() {
                        id = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (id != null) {
                        // Call the API to delete the station
                        final http.Response response = await deleteStation(id!);
                        if (response.statusCode == 200) {
                          // If the server returns a 200 OK response,
                          // then parse the JSON.
                          showSnackBar(context, 'Station Deleted Successfully');
                          List<Station> updatedStations =
                              await fetchAllStationsDetails();
                          setState(() {
                            stations = updatedStations;
                          });
                        } else {
                          // If the server returns an unexpected response,
                          // then throw an exception.
                          throw Exception('Failed to delete station');
                        }
                      }
                    },
                    child: Text('Delete Station'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
