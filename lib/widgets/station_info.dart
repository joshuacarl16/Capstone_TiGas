// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tigas_application/gmaps/google_map.dart';
import 'package:tigas_application/screens/rate_screen.dart';

class StationInfo extends StatelessWidget {
  const StationInfo({super.key});

  showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: RateDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shell',
                  style: GoogleFonts.ubuntu(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              Text('2.8km away',
                  style: GoogleFonts.catamaran(fontWeight: FontWeight.w600)),
              Text('Central Nautical Hwy, Consolacion',
                  style: GoogleFonts.catamaran(
                      fontWeight: FontWeight.w600, color: Colors.grey[600])),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton.extended(
                backgroundColor: Color(0xFF175124),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GMaps(
                        destination: '10.302085285784946, 123.91036554493864',
                      ),
                    ),
                  );
                },
                label: Text('Get Route'),
                icon: Icon(FontAwesomeIcons.route)),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton.extended(
              backgroundColor: Color(0xFF175124),
              onPressed: () {
                showRatingDialog(context);
              },
              label: Text('Rate Station'),
            ),
          ),
        ],
      ),
    );
  }
}
