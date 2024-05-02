import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

class ModifyPriceAndServices extends StatefulWidget {
  @override
  _ModifyPriceAndServicesState createState() => _ModifyPriceAndServicesState();
}

class _ModifyPriceAndServicesState extends State<ModifyPriceAndServices> {
  final Map<String, TextEditingController> _priceControllers = {};
  Map<String, bool> _services = {};
  Station? _selectedStation;
  final urlManager = UrlManager();

  @override
  void initState() {
    fetchAndLoadGasStations();
    super.initState();
    _selectedStation?.gasTypeInfo?.forEach((key, value) {
      _priceControllers[key] = TextEditingController(text: value);
    });
  }

  final Map<String, FaIcon> servicesIcons = {
    "Air": FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
    "Water": FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
    "Oil": FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
    "Restroom": FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
  };

  Future<void> fetchAndLoadGasStations() async {
    final stationProvider =
        Provider.of<StationProvider>(context, listen: false);
    await stationProvider.fetchStations();
  }

  Future<void> updateGasPrice() async {
    if (_selectedStation != null) {
      String url = await urlManager.getValidBaseUrl();
      var patchUrl = Uri.parse('$url/stations/${_selectedStation!.id}/update/');
      Map<String, String> newGasPrices = {};
      _priceControllers.forEach((key, controller) {
        newGasPrices[key] = controller.text;
      });

      var response = await http.patch(patchUrl,
          body: json.encode({'gasTypeInfo': newGasPrices}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        throw Exception('Failed to update gas price');
      }
    }
  }

  Future<void> updateServices() async {
    if (_selectedStation != null) {
      String url = await urlManager.getValidBaseUrl();
      var patchUrl = Uri.parse('$url/stations/${_selectedStation!.id}/update/');
      var availableServices =
          _services.keys.where((key) => _services[key]!).toList();

      var response = await http.patch(patchUrl,
          body: json.encode({'services': availableServices}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        throw Exception('Failed to update services');
      }
    }
  }

  Future<String?> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userSnapshot.get('role');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var stationProvider = Provider.of<StationProvider>(context);
    return Scaffold(
      body: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error fetching user role'));
          } else {
            String userRole = snapshot.data!;
            List<Station> filteredStations = stationProvider.stations
                .where((station) => station.name.contains(userRole))
                .toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      '$userRole Stations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<Station>(
                    isExpanded: true,
                    value: _selectedStation,
                    onChanged: (Station? newValue) {
                      setState(() {
                        _selectedStation = newValue;
                        _priceControllers.clear();
                        _services.clear();
                        _selectedStation?.gasTypeInfo?.forEach((key, value) {
                          _priceControllers[key] =
                              TextEditingController(text: value);
                        });
                        _services = {
                          for (var service in [
                            'Oil',
                            'Water',
                            'Air',
                            'Restroom'
                          ])
                            service:
                                _selectedStation!.services!.contains(service)
                        };
                      });
                    },
                    items: filteredStations
                        .map<DropdownMenuItem<Station>>((Station station) {
                      return DropdownMenuItem<Station>(
                        value: station,
                        child: Text(station.address),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  const Center(
                      child: Text(
                    'Price Update',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  if (_selectedStation != null)
                    ..._priceControllers.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: entry.value,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await updateGasPrice();
                      showSnackBar(context, 'Gas Prices Updated');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Update Prices',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  const Center(
                      child: Text(
                    'Service Availability',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  ..._services.keys.map((String key) {
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          servicesIcons[key] ?? const SizedBox(),
                          const SizedBox(width: 8),
                          Text(key),
                        ],
                      ),
                      value: _services[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _services[key] = value!;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await updateServices();
                      showSnackBar(context, 'Services Updated');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Update Services',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
