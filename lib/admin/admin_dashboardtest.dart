import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tigas_application/styles/styles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedPanel = 'Gas Prices';
  List<String> _panelOptions = ['Gas Prices', 'Services Availability'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/TiGas.png',
            fit: BoxFit.contain,
            height: 140,
          ),
          backgroundColor: Color(0xFF609966),
          elevation: 0,
        ),
        body: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_gas_station, color: Colors.blue),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'abc',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '123',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedPanel,
                      iconSize: 30,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPanel = newValue!;
                        });
                      },
                      items: _panelOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildPanel(_selectedPanel),
                ),
              ],
            ),
          )
        ]));
  }

  Widget _buildPanel(String panelTitle) {
    // Switch between panels based on the selected title
    switch (panelTitle) {
      case 'Gas Prices':
        return _buildGasPricesPanel();
      case 'Services Availability':
        return _buildServicesAvailabilityPanel();
      default:
        return _buildGasPricesPanel();
    }
  }

  Widget _buildGasPricesPanel() {
    // TODO: Build your Gas Prices panel widget here
    return Center(child: Text('Gas Prices Panel'));
  }

  Widget _buildServicesAvailabilityPanel() {
    // TODO: Build your Services Availability panel widget here
    return Center(child: Text('Services Availability Panel'));
  }
}
