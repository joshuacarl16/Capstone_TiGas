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
    // Added null check for context
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<StationProvider>(context, listen: false)
          .fetchStations()
          .then((_) {
        if (mounted) {
          var stationProvider =
              Provider.of<StationProvider>(context, listen: false);
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
    });
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
      child: Container(
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
            // Removed extra comma
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Update Services'),
            ),
          ],
        ),
      ),
    );
  }
}
