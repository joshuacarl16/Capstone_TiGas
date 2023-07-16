import 'package:flutter/material.dart';


class ModifyPriceServices extends StatefulWidget {
  @override
  _ModifyPriceServicesState createState() => _ModifyPriceServicesState();
}

class _ModifyPriceServicesState extends State<ModifyPriceServices> {
  final TextEditingController _priceController = TextEditingController();
  String _selectedGasType = 'Gasoline'; // Default selection
  final Map<String, String> _gasPrices = {
    'Gasoline': '',
    'Diesel': ''
  }; // Default prices

  Map<String, bool> services = {
    'Oil': false,
    'Water': false,
    'Air': false,
    'CR': false,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                        _selectedGasType = newValue!;
                      });
                    },
                    items: <String>['Gasoline', 'Diesel']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                    onPressed: () {
                      setState(() {
                        _gasPrices[_selectedGasType] = _priceController.text;
                      });
                    },
                    child: Text('Update Price'),
                  ),
                  Text('Gasoline Price: ₱${_gasPrices['Gasoline']}'),
                  Text('Diesel Price: ₱${_gasPrices['Diesel']}'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
