import 'package:flutter/material.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tigas_application/widgets/show_snackbar.dart';

class AddStation extends StatefulWidget {
  AddStation({Key? key}) : super(key: key);

  @override
  _AddStationState createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? imagePath, brand, address, gasTypes, gasTypeInfo, services;
  double? distance;
  List<Station> station = [];
  int? id;

  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController gasTypesController = TextEditingController();
  final TextEditingController gasTypeInfoController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();

  List<String> imagePaths = [
    'assets/shell.png',
    'assets/caltex.png',
    'assets/petron.png',
    'assets/phoenix.png',
    'assets/total.png',
    'assets/seaoil.png'
  ];
  List<String> brands = [
    'Shell',
    'Caltex',
    'Petron',
    'Phoenix',
    'Total',
    'Seaoil'
  ];

  Future<http.Response> createStation() {
    return http.post(
      Uri.parse('http://192.168.1.4:8000/stations/create/'),
      // Uri.parse('http://127.0.0.1:8000/stations/create/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'imagePath': imagePathController.text,
        'brand': brandController.text,
        'address': addressController.text,
        'distance': double.tryParse(distanceController.text),
        'gasTypes':
            gasTypesController.text.split(',').map((e) => e.trim()).toList(),
        'gasTypeInfo':
            gasTypeInfoController.text.split(',').fold({}, (map, item) {
          var parts = item.split(':');
          if (parts.length == 2) {
            map[parts[0].trim()] = parts[1].trim();
          }
          return map;
        }),
        'services':
            servicesController.text.split(',').map((e) => e.trim()).toList(),
      }),
    );
  }

  Future<List<Station>> fetchStations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.4:8000/stations/')); //phone
    // await http.get(Uri.parse('http://127.0.0.1:8000/stations/')); //web
    if (response.statusCode == 200) {
      List jsonResponse =
          jsonDecode(response.body); // Add this line to inspect the response
      return jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<http.Response> deleteStation(int id) {
    return http.delete(
      Uri.parse('http://192.168.1.4:8000/stations/$id/delete/'),
      //  Uri.parse('http://127.0.0.1:8000/stations/$id/delete/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  @override
  void dispose() {
    imagePathController.dispose();
    brandController.dispose();
    addressController.dispose();
    distanceController.dispose();
    gasTypesController.dispose();
    gasTypeInfoController.dispose();
    servicesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchStations().then((value) {
      setState(() {
        station = value;
      });
    });
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Image'),
                    items: imagePaths.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        imagePathController.text = newValue.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an image path';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Brand'),
                    items: brands.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        brandController.text = newValue.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    onSaved: (value) {
                      address = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: distanceController,
                    decoration: InputDecoration(labelText: 'Distance'),
                    onSaved: (value) {
                      distance = double.tryParse(value ?? '');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter distance';
                      }
                      if (double.tryParse(value) == null) {
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
                      gasTypes = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gas types';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: gasTypeInfoController,
                    decoration: InputDecoration(labelText: 'Gas Type Info'),
                    onSaved: (value) {
                      gasTypeInfo = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gas type info';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: servicesController,
                    decoration: InputDecoration(labelText: 'Services'),
                    onSaved: (value) {
                      services = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter services';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Call the API to create a new station
                      final http.Response response = await createStation();
                      if (response.statusCode == 200) {
                        // If the server returns a 200 OK response,
                        // then parse the JSON.
                        print('Station created successfully');
                        showSnackBar(context, 'Station Created Successfully');
                        List<Station> updatedStations = await fetchStations();
                        setState(() {
                          station = updatedStations;
                        });
                      } else {
                        // If the server returns an unexpected response,
                        // then throw an exception.
                        throw Exception('Failed to create station');
                      }
                    },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Station'),
                    items: station.map((Station value) {
                      return DropdownMenuItem<int>(
                        value: value.id,
                        child: Text(value.id.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        id = newValue as int;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a station';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Call the API to delete the selected station
                      final http.Response response = await deleteStation(id!);
                      if (response.statusCode == 200) {
                        // If the server returns a 200 OK response,
                        // then parse the JSON.
                        print('Station deleted successfully');
                        showSnackBar(context, 'Station Deleted Successfully');

                        // Fetch the updated list of stations
                        List<Station> updatedStations = await fetchStations();
                        setState(() {
                          station = updatedStations;
                          id = null;
                        });
                      } else {
                        // If the server returns an unexpected response,
                        // then throw an exception.
                        throw Exception('Failed to delete station');
                      }
                    },
                    child: Text('Delete Selected Station'),
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
