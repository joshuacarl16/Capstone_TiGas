// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tigas_application/screens/map_screen.dart';

class StationInfo extends StatelessWidget {
  const StationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: ClipRRect(
              child: Image.asset(
                'assets/shell.png',
                height: 60,
                width: 60,
              ),
            ),
          ),
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
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
                backgroundColor: Color(0xFF175124),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MapScreen(),
                  //   ),
                  // );
                },
                child: Icon(Icons.drive_eta)),
          ),
        ],
      ),
    );
  }
}
