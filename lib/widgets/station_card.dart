import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StationCard extends StatelessWidget {
  const StationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Material(
          elevation: 5,
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey[500]!),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '2.8km',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/shell.png',
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SHELL',
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))),
                              Text(
                                'Central Nautical Hwy, Conso...',
                                style: GoogleFonts.catamaran(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green),
                        Text(
                          'Air',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.circle, color: Colors.green),
                        Text(
                          'Water',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.circle, color: Colors.green),
                        Text(
                          'Oil',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.circle, color: Colors.red),
                        Text(
                          'CR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Regular',
                              style: GoogleFonts.catamaran(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '12.34',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 70.0,
                          child: VerticalDivider(
                            color: Colors.black,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Diesel',
                              style: GoogleFonts.catamaran(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '56.78',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 70.0,
                          child: VerticalDivider(
                            color: Colors.black,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Premium',
                              style: GoogleFonts.catamaran(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '90.12',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
