import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class StationCard extends StatelessWidget {
  final String imagePath;
  final String brand;
  final String address;
  final String distance;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;
  final List<FaIcon> services;

  const StationCard({
    Key? key,
    required this.imagePath,
    required this.brand,
    required this.address,
    required this.distance,
    required this.gasTypes,
    required this.gasTypeInfo,
    required this.services,
  }) : super(key: key);

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
                    distance,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 1.6 * unitHeightValue),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 3 * unitWidthValue,
              top: -2 * unitHeightValue,
              child: ClipRRect(
                child: Image.asset(
                  imagePath,
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
                            Text(brand,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 3 * unitHeightValue,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              address,
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
                        _buildServicesIcons(unitWidthValue, unitHeightValue),
                  ),
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
      children: List<Widget>.generate(gasTypes.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          // even index, build gas type info
          String type = gasTypes[index ~/ 2];
          return _buildGasTypeInfo(
              type, gasTypeInfo[type]!, unitHeightValue, unitWidthValue);
        } else {
          // odd index, build divider
          return _buildDivider(unitHeightValue);
        }
      }),
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
      for (var icon in services) ...[
        icon,
        SizedBox(
          width: 5 * unitWidthValue,
        )
      ]
    ];
  }

  // Row _buildServiceIcon(IconData icon, Color color, String label,
  //     double unitWidthValue, double unitHeightValue) {
  //   return Row(
  //     children: [
  //       FaIcon(icon, color: color, size: 2.4 * unitHeightValue),
  //       Text(
  //         label,
  //         style: TextStyle(
  //             fontWeight: FontWeight.bold, fontSize: 1.6 * unitHeightValue),
  //       ),
  //       SizedBox(width: 1.2 * unitWidthValue),
  //     ],
  //   );
  // }
}
