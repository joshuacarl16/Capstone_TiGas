import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tigas_application/admin_widgets/price_services.dart';
import 'package:tigas_application/admin_widgets/post_advertisements.dart';
import 'package:tigas_application/admin_widgets/update_timestamp.dart';
import 'package:tigas_application/styles/styles.dart';

import '../screens/loading_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedPanel = 'Station Update Timestamp';
  List<String> _panelOptions = [
    'Station Update Timestamp',
    'Edit Station Info',
    'Post Advertisements',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => LoadingScreen()),
              ),
            );
          },
        ),
        title: Image.asset(
          'assets/TiGas.png',
          fit: BoxFit.contain,
          height: 140,
        ),
        backgroundColor: const Color(0xFF609966),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: const Color(0xFF609966),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: const Color(0xFF609966),
                      isExpanded: true,
                      value: _selectedPanel,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPanel = newValue;
                          });
                        }
                      },
                      items: _panelOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: _buildPanel(_selectedPanel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(String panelTitle) {
    switch (panelTitle) {
      case 'Station Update Timestamp':
        return UpdateTimestamp();
      case 'Edit Station Info':
        return ModifyPriceAndServices();
      case 'Post Advertisements':
        return PostAdvertisement();
      default:
        return UpdateTimestamp();
    }
  }
}
