import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'station_model.dart';

List<Station> stations = [
  Station(
    imagePath: 'assets/shell.png',
    brand: 'SHELL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '1.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/petron.png',
    brand: 'PETRON',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '1.2km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/caltex.png',
    brand: 'CALTEX',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '1.4km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/seaoil.png',
    brand: 'SEAOIL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '1.6km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/total.png',
    brand: 'TOTAL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '1.8km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/shell.png',
    brand: 'SHELL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '2.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/petron.png',
    brand: 'PETRON',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '2.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/caltex.png',
    brand: 'CALTEX',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '2.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/seaoil.png',
    brand: 'SEAOIL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '2.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  ),
  Station(
    imagePath: 'assets/total.png',
    brand: 'TOTAL',
    address: 'Central Nautical Hwy, Consolacion',
    distance: '2.0km',
    gasTypes: ['Regular', 'Diesel', 'Premium'],
    gasTypeInfo: {
      'Regular': '12.34',
      'Diesel': '56.78',
      'Premium': '90.12',
    },
    services: [
      FaIcon(FontAwesomeIcons.wind, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.droplet, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.oilCan, color: Colors.green[700]),
      FaIcon(FontAwesomeIcons.restroom, color: Colors.green[700]),
    ],
  )
];
