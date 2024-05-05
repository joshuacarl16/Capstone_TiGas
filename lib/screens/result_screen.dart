// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';

class ResultScreen extends StatefulWidget {
  final Station selectedStation;
  final Map<String, String>? scannedGasPrices;
  final List<String> processLogs;

  const ResultScreen({
    Key? key,
    required this.selectedStation,
    this.scannedGasPrices,
    required this.processLogs,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, TextEditingController> _controllers = {};
  final urlManager = UrlManager();

  @override
  void initState() {
    super.initState();
    if (widget.selectedStation.gasTypeInfo != null) {
      widget.selectedStation.gasTypeInfo!.forEach((key, value) {
        String initialText;
        if (widget.scannedGasPrices != null &&
            widget.scannedGasPrices!.containsKey(key)) {
          initialText = widget.scannedGasPrices![key]!;
        } else {
          initialText = value.toString();
        }
        _controllers[key] = TextEditingController(text: initialText);
      });
    }
  }

  Future<void> updateGasPrice() async {
    String baseUrl = await urlManager.getValidBaseUrl();
    var url = Uri.parse(
        '$baseUrl/stations/${widget.selectedStation.id}/prices/submit/');

    // Prepare a dictionary to accumulate all gas types and prices
    Map<String, String> accumulatedGasInfo = {};

    String? uploadedBy;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      uploadedBy = (snapshot.data() as Map<String, dynamic>?)?['displayname'];
    } catch (e) {
      uploadedBy = 'Unknown';
    }

    // Loop through each gas type and price controller
    _controllers.forEach((gasType, controller) {
      String priceStr = controller.text;
      try {
        double priceValue =
            double.parse(priceStr); // Parse price string to double
        String formattedPriceStr = priceValue
            .toStringAsFixed(2); // Format price to two decimal places as string
        accumulatedGasInfo[gasType] =
            formattedPriceStr; // Add to accumulated gas info
      } catch (e) {
        // Handle invalid price parsing
        print('Invalid price for $gasType: $priceStr');
      }
    });

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'uploaded_by': uploadedBy, // Set the uploaded_by field as desired
      'gasTypeInfo': accumulatedGasInfo,
    };

    try {
      var response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submitted price update'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to NavBar screen after showing success message
        Future.delayed(Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => NavBar(selectedTab: 1)),
            ),
          );
        });
      } else {
        throw Exception('Failed to update gas price');
      }
    } catch (e) {
      print('Error updating gas price: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update gas price. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: const Text('Scanned Prices'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              ..._controllers.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(entry.key,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          ' (Current: ${widget.selectedStation.gasTypeInfo?[entry.key]})',
                          style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: entry.value,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: () async {
                  await updateGasPrice();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Submitted price update'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => NavBar(
                              selectedTab: 1,
                            )),
                      ),
                    );
                  });
                },
                child: const Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
}
