import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StationCard extends StatelessWidget {
  const StationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 3 * unitWidthValue, vertical: 1.5 * unitHeightValue),
      child: Material(
        elevation: 5,
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.2 * unitWidthValue),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 1.6 * unitHeightValue),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.4 * unitWidthValue, color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.6 * unitWidthValue),
                  child: Text(
                    '2.8km',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 1.6 * unitHeightValue),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 3 * unitWidthValue,
              top: -3 * unitHeightValue,
              child: ClipRRect(
                child: Image.asset(
                  'assets/shell.png',
                  height: 16 * unitHeightValue,
                  width: 16 * unitWidthValue,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3 * unitWidthValue),
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
                                    fontSize: 3 * unitHeightValue,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              'Central Nautical Hwy, Conso...',
                              style: GoogleFonts.catamaran(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                  fontSize: 1.6 * unitHeightValue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: unitHeightValue,
                  ),
                  Row(
                      children:
                          _buildServicesIcons(unitWidthValue, unitHeightValue)),
                  SizedBox(height: unitHeightValue),
                  _buildGasTypes(unitHeightValue, unitWidthValue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildGasTypes(double unitHeightValue, double unitWidthValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGasTypeInfo('Regular', '12.34', unitHeightValue, unitWidthValue),
        _buildDivider(unitHeightValue),
        _buildGasTypeInfo('Diesel', '56.78', unitHeightValue, unitWidthValue),
        _buildDivider(unitHeightValue),
        _buildGasTypeInfo('Premium', '90.12', unitHeightValue, unitWidthValue),
      ],
    );
  }

  Column _buildGasTypeInfo(String type, String price, double unitHeightValue,
      double unitWidthValue) {
    return Column(
      children: [
        Text(
          type,
          style: GoogleFonts.catamaran(
            fontSize: 2 * unitHeightValue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 1.6 * unitHeightValue,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Container _buildDivider(double unitHeightValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2 * unitHeightValue),
      height: 7 * unitHeightValue,
      child: VerticalDivider(
        color: Colors.black,
        indent: unitHeightValue,
        endIndent: unitHeightValue,
      ),
    );
  }

  List<Widget> _buildServicesIcons(
      double unitWidthValue, double unitHeightValue) {
    return [
      _buildServiceIcon(
          Icons.circle, Colors.green, 'Air', unitWidthValue, unitHeightValue),
      SizedBox(width: unitWidthValue),
      _buildServiceIcon(
          Icons.circle, Colors.green, 'Water', unitWidthValue, unitHeightValue),
      SizedBox(width: unitWidthValue),
      _buildServiceIcon(
          Icons.circle, Colors.green, 'Oil', unitWidthValue, unitHeightValue),
      SizedBox(width: unitWidthValue),
      _buildServiceIcon(
          Icons.circle, Colors.red, 'Restroom', unitWidthValue, unitHeightValue)
    ];
  }

  Row _buildServiceIcon(IconData icon, Color color, String label,
      double unitWidthValue, double unitHeightValue) {
    return Row(
      children: [
        Icon(icon, color: color, size: 2.4 * unitHeightValue),
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 1.6 * unitHeightValue),
        ),
        SizedBox(width: 1.2 * unitWidthValue),
      ],
    );
  }
}
