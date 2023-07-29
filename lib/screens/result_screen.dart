// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    var url =
        Uri.parse('$baseUrl/stations/${widget.selectedStation.id}/update/');
    Map<String, String> newGasPrices = {};
    _controllers.forEach((key, value) {
      newGasPrices[key] = value.text;
    });

    var response = await http.patch(url,
        body: json.encode({'gasTypeInfo': newGasPrices}),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode != 200) {
      throw Exception('Failed to update gas price');
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          ' (Current: ${entry.value.text})',
                          style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: () async {
                  await updateGasPrice();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Submitted price update'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  Future.delayed(Duration(seconds: 3), () {
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
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Logs',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ],
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: widget.processLogs.length,
                  itemBuilder: (context, index) {
                    return Text(widget.processLogs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
