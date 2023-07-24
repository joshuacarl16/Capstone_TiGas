// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Station {
  final int id;
  final String imagePath;
  final String brand;
  final String address;
  final double distance;
  final List<String> gasTypes;
  final Map<String, String> gasTypeInfo;
  final List<String> services;
  final DateTime updated;

  Station({
    required this.id,
    required this.imagePath,
    required this.brand,
    required this.address,
    required this.distance,
    required this.gasTypes,
    required this.gasTypeInfo,
    required this.services,
    required this.updated,
  });

  Station copyWith({
    int? id,
    String? imagePath,
    String? brand,
    String? address,
    double? distance,
    List<String>? gasTypes,
    Map<String, String>? gasTypeInfo,
    List<String>? services,
    DateTime? updated,
  }) {
    return Station(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      brand: brand ?? this.brand,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      gasTypes: gasTypes ?? this.gasTypes,
      gasTypeInfo: gasTypeInfo ?? this.gasTypeInfo,
      services: services ?? this.services,
      updated: updated ?? this.updated,
    );
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'],
      imagePath: map['imagePath'],
      brand: map['brand'],
      address: map['address'],
      distance: (map['distance'] as num).toDouble(),
      gasTypes: List<String>.from(map['gasTypes']),
      gasTypeInfo: Map<String, String>.from(map['gasTypeInfo']),
      services: List<String>.from(map['services']),
      updated: DateTime.parse(map['updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'brand': brand,
      'address': address,
      'distance': distance,
      'gasTypes': gasTypes,
      'gasTypeInfo': gasTypeInfo,
      'services': services,
      'updated': updated.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) =>
      Station.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Station(id: $id, imagePath: $imagePath, brand: $brand, address: $address, distance: $distance, gasTypes: $gasTypes, gasTypeInfo: $gasTypeInfo, services: $services, updated: $updated,)';
  }

  @override
  bool operator ==(covariant Station other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.imagePath == imagePath &&
        other.brand == brand &&
        other.address == address &&
        other.distance == distance &&
        listEquals(other.gasTypes, gasTypes) &&
        mapEquals(other.gasTypeInfo, gasTypeInfo) &&
        listEquals(other.services, services) &&
        other.updated == updated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imagePath.hashCode ^
        brand.hashCode ^
        address.hashCode ^
        distance.hashCode ^
        gasTypes.hashCode ^
        gasTypeInfo.hashCode ^
        services.hashCode ^
        updated.hashCode;
  }
}
