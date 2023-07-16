import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Station {
  final String imagePath;
  final String brand;
  final String address;
  final String distance;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;
  final List<FaIcon> services;

  Station({
    required this.imagePath,
    required this.brand,
    required this.address,
    required this.distance,
    required this.gasTypes,
    required this.gasTypeInfo,
    required this.services,
  });
}
