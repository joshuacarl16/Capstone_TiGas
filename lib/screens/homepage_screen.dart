// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';

class HomePage extends StatelessWidget {
  final int selectedTab;

  const HomePage({Key? key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Current Location',
                    filled: true,
                    fillColor: Colors.grey[300]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  SizedBox(width: 16.0),
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
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  // Replace with your item builder logic
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                        'Placeholder.............',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(selectedTab: selectedTab),
    );
  }
}
