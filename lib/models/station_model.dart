import 'dart:convert';

import 'package:flutter/foundation.dart';

class Station {
  final int id;
  final String? imagePath;
  final String name;
  final String address;
  final double? distance;
  final List<String>? gasTypes;
  final Map<String, String>? gasTypeInfo;
  final List<String>? services;
  final DateTime updated;
  final double latitude;
  final double longitude;
  final String place_id;
  final Map<String, dynamic>? opening_hours;

  Station({
    required this.id,
    this.imagePath,
    required this.name,
    required this.address,
    this.distance,
    this.gasTypes,
    this.gasTypeInfo,
    this.services,
    required this.updated,
    required this.latitude,
    required this.longitude,
    required this.place_id,
    this.opening_hours,
  });

  Station copyWith({
    int? id,
    String? imagePath,
    String? name,
    String? address,
    double? distance,
    List<String>? gasTypes,
    Map<String, String>? gasTypeInfo,
    List<String>? services,
    DateTime? updated,
    double? latitude,
    double? longitude,
    String? place_id,
    Map<String, dynamic>? opening_hours,
  }) {
    return Station(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      gasTypes: gasTypes ?? this.gasTypes,
      gasTypeInfo: gasTypeInfo ?? this.gasTypeInfo,
      services: services ?? this.services,
      updated: updated ?? this.updated,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      place_id: place_id ?? this.place_id,
      opening_hours: opening_hours ?? this.opening_hours,
    );
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'],
      imagePath: map['imagePath'],
      name: map['name'],
      address: map['address'],
      distance:
          map['distance'] != null ? (map['distance'] as num).toDouble() : null,
      gasTypes:
          map['gasTypes'] != null ? List<String>.from(map['gasTypes']) : null,
      gasTypeInfo: map['gasTypeInfo'] != null
          ? Map<String, String>.from(map['gasTypeInfo'])
          : null,
      services: map['services'] != null
          ? (map['services'] as List<dynamic>).cast<String>()
          : null,
      updated: DateTime.parse(map['updated']),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      place_id: map['place_id'],
      opening_hours: map['opening_hours'] != null
          ? Map<String, dynamic>.from(map['opening_hours'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'address': address,
      'distance': distance,
      'gasTypes': gasTypes,
      'gasTypeInfo': gasTypeInfo,
      'services': services,
      'updated': updated.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'place_id': place_id,
      'opening_hours': opening_hours,
    };
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) {
    final Map<String, dynamic> map = json.decode(source);
    return Station(
      id: map['id'],
      imagePath: map['imagePath'],
      name: map['name'],
      address: map['address'],
      distance:
          map['distance'] != null ? (map['distance'] as num).toDouble() : null,
      gasTypes: map['gasTypes'] != null
          ? (map['gasTypes'] as String).split(', ')
          : null,
      gasTypeInfo: map['gasTypeInfo'] != null
          ? Map<String, String>.from(map['gasTypeInfo'])
          : null,
      services: map['services'] != null
          ? (map['services'] as String).split(', ')
          : null,
      updated: DateTime.parse(map['updated']),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      place_id: map['place_id'],
      opening_hours: map['opening_hours'] != null
          ? Map<String, dynamic>.from(map['opening_hours'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Station(id: $id, imagePath: $imagePath, name: $name, address: $address, distance: $distance, gasTypes: $gasTypes, gasTypeInfo: $gasTypeInfo, services: $services, updated: $updated, latitude: $latitude, longitude: $longitude, place_id: $place_id, opening_hours: $opening_hours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Station &&
        other.id == id &&
        other.imagePath == imagePath &&
        other.name == name &&
        other.address == address &&
        other.distance == distance &&
        listEquals(other.gasTypes, gasTypes) &&
        mapEquals(other.gasTypeInfo, gasTypeInfo) &&
        listEquals(other.services, services) &&
        other.updated == updated &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.place_id == place_id &&
        mapEquals(other.opening_hours, opening_hours);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        (imagePath?.hashCode ?? 0) ^
        name.hashCode ^
        address.hashCode ^
        (distance?.hashCode ?? 0) ^
        (gasTypes?.hashCode ?? 0) ^
        (gasTypeInfo?.hashCode ?? 0) ^
        (services?.hashCode ?? 0) ^
        updated.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        place_id.hashCode ^
        (opening_hours?.hashCode ?? 0);
  }
}
