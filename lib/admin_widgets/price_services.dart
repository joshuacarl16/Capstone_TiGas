import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

class ModifyPriceServices extends StatefulWidget {
  @override
  _ModifyPriceServicesState createState() => _ModifyPriceServicesState();
}

class _ModifyPriceServicesState extends State<ModifyPriceServices> {
  final TextEditingController _priceController = TextEditingController();
  String? _selectedGasType;
  Station? _selectedStation;
  Map<String, String> _gasPrices = {
    'Regular': '',
    'Diesel': '',
    'Premium': ''
  }; // Default prices

  Map<String, List<String>> brandGasTypes = {
    'Shell': [
      'FuelSave Unleaded',
      'V-Power Gasoline',
      'FuelSave Diesel',
      'V-Power Diesel'
    ],
    'Caltex': ['Silver', 'Platinum', 'Diesel'],
    'Petron': [
      'Blaze 100 Euro 6',
      'XCS',
      'Xtra Advance',
      'Turbo Diesel',
      'Diesel Max'
    ],
    'Phoenix': ['Diesel', 'Super', 'Premium 95', 'Premium 98'],
    'Jetti': ['DieselMaster', 'Accelrate', 'JX Premium'],
    'Total': ['Excellium Unleaded', 'Excellium Diesel'],
    'Seaoil': ['Extreme 97', 'Extreme 95', 'Extreme U', 'Extreme Diesel'],
  };

  Map<String, bool> services = {};
  final urlManager = UrlManager();

  @override
  void initState() {
    super.initState();
    Provider.of<StationProvider>(context, listen: false)
        .fetchStations()
        .then((_) {
      if (mounted) {
        // Get reference to the provider
        var stationProvider =
            Provider.of<StationProvider>(context, listen: false);

        // If there are any stations, set the selected station to the first one
        if (stationProvider.stations.isNotEmpty) {
          setState(() {
            _selectedStation = stationProvider.stations.first;
            _gasPrices = {...?_selectedStation?.gasTypeInfo};
            services = {
              for (var service in ['Oil', 'Water', 'Air', 'Restroom'])
                service: _selectedStation!.services!.contains(service)
            };
          });
        }
      }
    });
  }

  Future<void> updateGasPrice() async {
    if (_selectedStation != null && _selectedGasType != null) {
      String url = await urlManager.getValidBaseUrl();
      var patchUrl = Uri.parse('$url/stations/${_selectedStation!.id}/update/');
      var newGasPrice = {_selectedGasType: _priceController.text};
      var oldGasTypeInfo = _selectedStation!.gasTypeInfo ?? {};
      var newGasTypeInfo = {...oldGasTypeInfo, ...newGasPrice};

      var response = await http.patch(patchUrl,
          body: json.encode({'gasTypeInfo': newGasTypeInfo}),
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
          services.keys.where((key) => services[key]!).toList();

      var response = await http.patch(patchUrl,
          body: json.encode({'services': availableServices}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        throw Exception('Failed to update services');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var stationProvider = Provider.of<StationProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<Station>(
              value: _selectedStation,
              onChanged: (Station? newValue) {
                setState(() {
                  _selectedStation = newValue;
                  _gasPrices =
                      Map<String, String>.from(_selectedStation!.gasTypeInfo!);
                  services = {
                    for (var service in ['Oil', 'Water', 'Air', 'Restroom'])
                      service: _selectedStation!.services!.contains(service)
                  };
                });
              },
              items: stationProvider.stations
                  .map<DropdownMenuItem<Station>>((Station station) {
                return DropdownMenuItem<Station>(
                  value: station,
                  child: Text(station.address),
                );
              }).toList(),
            ),
            // Gas Price Section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Column(
                children: [
                  Text('Modify Gas Price'),
                  DropdownButton<String>(
                    value: _selectedGasType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGasType = newValue;
                      });
                    },
                    items: (_selectedStation != null)
                        ? brandGasTypes.entries
                            .where((entry) => _selectedStation!.name
                                .toLowerCase()
                                .contains(entry.key.toLowerCase()))
                            .expand((entry) => entry.value)
                            .map<DropdownMenuItem<String>>((String gasType) {
                            return DropdownMenuItem<String>(
                              value: gasType,
                              child: Text(gasType),
                            );
                          }).toList()
                        : [], // return an empty list if the brand does not exist
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'New Gas Price',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        if (_priceController.text.isNotEmpty &&
                            _selectedGasType != null) {
                          _gasPrices[_selectedGasType!] = _priceController.text;
                        }
                      });
                      await updateGasPrice();
                      showSnackBar(context, 'Station Prices Updated');
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Update Prices'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: _selectedStation != null
                        ? _selectedStation!.gasTypeInfo!.entries.map((entry) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${entry.key}: ₱${entry.value}'),
                                if (_selectedGasType == entry.key)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                        'Updated: ₱${_priceController.text}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            );
                          }).toList()
                        : [],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Service Availability Section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Column(
                children: [
                  Text('Service Availability'),
                  ...services.keys.map((String key) {
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
                  ElevatedButton(
                    onPressed: () async {
                      await updateServices();
                      showSnackBar(context, 'Station Services Updated');
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Update Services'),
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
