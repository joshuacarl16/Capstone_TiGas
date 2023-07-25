import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class CommercialPage extends StatefulWidget {
  final int selectedTab;
  CommercialPage({super.key, required this.selectedTab});

  @override
  _CommercialPageState createState() => _CommercialPageState();
}

class _CommercialPageState extends State<CommercialPage> {
  List<Map<String, dynamic>> advertisements = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    fetchAdvertisements();
  }

  Future<void> fetchAdvertisements() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/images/'));
    // await http.get(Uri.parse('http://192.168.1.4:8000/images/')); //used for external device

    if (response.statusCode == 200) {
      List<dynamic> ads = json.decode(response.body);
      setState(() {
        advertisements = ads
            .map<Map<String, dynamic>>((ad) => {
                  'image': 'http://127.0.0.1:8000${ad['image']}',
                  // 'image': 'http://192.168.1.4:8000${ad['image']}', //used for external device
                  'caption': ad['caption'],
                  'updated': convertTime(ad['updated'])
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load advertisements');
    }
  }

  String convertTime(String time) {
    DateTime updatedUtc = DateTime.parse(time); // Parse the updated time in UTC
    tz.TZDateTime updated = tz.TZDateTime.from(
        updatedUtc, tz.getLocation('Asia/Manila')); // Convert to Manila time

    return DateFormat('yyyy-MM-dd - hh:mm a')
        .format(updated); // format updated time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 270,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: Text('PARTNERS',
                    style: GoogleFonts.signika(fontWeight: FontWeight.bold)),
                background: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              backgroundColor: Color(0xFF609966),
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color(0xFF609966),
                Color(0xFF175124),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: advertisements.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> ad = advertisements[index];
                    String imagePath = ad['image'];
                    String adText = ad['caption'];
                    String updatedTime = ad['updated'];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Material(
                              elevation: 5,
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Text('Could not load image');
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            adText,
                            style: GoogleFonts.catamaran(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Last Updated: $updatedTime',
                            style: GoogleFonts.catamaran(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
