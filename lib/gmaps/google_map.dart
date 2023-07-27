import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:tigas_application/gmaps/points.dart';
import 'package:image/image.dart' as img;

class GMaps extends StatefulWidget {
  const GMaps({Key? key, required this.destination}) : super(key: key);

  final String destination;

  @override
  State<GMaps> createState() => GMapsState();
}

class GMapsState extends State<GMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLngBounds? lastBounds;
  List<BitmapDescriptor> customIcons = [];
  String? location;
  Marker? _currentLocationMarker;
  BitmapDescriptor? currentLocationIcon;
  List<Marker> gasStationMarkers = [];

  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;

  Future<Uint8List> resizeImage(
      Uint8List data, int targetWidth, int targetHeight) async {
    img.Image? originalImage = img.decodeImage(data);

    if (originalImage != null) {
      img.Image resizedImage = img.copyResize(originalImage,
          width: targetWidth, height: targetHeight);
      return Uint8List.fromList(img.encodePng(resizedImage));
    } else {
      throw Exception('Failed to resize image');
    }
  }

  Future<void> loadMarkers() async {
    customIcons = List<BitmapDescriptor>.empty(growable: true);

    final markerImages = ['assets/station.png', 'assets/currentloc.png'];

    for (var i = 0; i < markerImages.length; i++) {
      final byteData = await rootBundle.load(markerImages[i]);
      final Uint8List resizedBytes =
          await resizeImage(byteData.buffer.asUint8List(), 80, 80);
      if (i == 0) {
        customIcons.add(BitmapDescriptor.fromBytes(resizedBytes));
      } else if (i == 1) {
        currentLocationIcon = BitmapDescriptor.fromBytes(resizedBytes);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRoute(widget.destination);
      getGasStations();
    });
    loadMarkers();
  }

  Set<Marker> _createMarker() {
    var markers = <Marker>{};

    for (var i = 0; i < points.length; i++) {
      markers.addAll(gasStationMarkers);
      // markers.add(Marker(
      //     markerId: MarkerId('marker$i'),
      //     position: points[i],
      //     infoWindow: InfoWindow(title: 'Gas Station $i'),
      //     icon: customIcons[i % customIcons.length]));
    }
    if (_currentLocationMarker != null) {
      markers.add(_currentLocationMarker!);
    }
    return markers;
  }

  void setCurrentLocationMarker(Position currentPosition) {
    _currentLocationMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: currentLocationIcon ?? BitmapDescriptor.defaultMarker,
    );
  }

  void getRoute(String destination) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String currentpos = "${position.latitude}, ${position.longitude}";

    setCurrentLocationMarker(position);

    var directions =
        await LocationService().getDirections(currentpos, destination);

    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    _setPolyline(directions['polyline_decoded']);
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    lastBounds = LatLngBounds(
        southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
        northeast: LatLng(boundsNe['lat'], boundsNe['lng']));

    controller.animateCamera(CameraUpdate.newLatLngBounds(lastBounds!, 25));
  }

  void _setPolyline(List<PointLatLng> points) {
    String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    setState(() {
      _polylines.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 6,
            color: Colors.green,
            points: points
                .map(
                  (point) => LatLng(point.latitude, point.longitude),
                )
                .toList()),
      );
    });
  }

  LatLng calculateMidPoint(LatLng southwest, LatLng northeast) {
    return LatLng(
      (southwest.latitude + northeast.latitude) / 2,
      (southwest.longitude + northeast.longitude) / 2,
    );
  }

  Future<void> getGasStations() async {
    try {
      List<Map<String, dynamic>> gasStations =
          await LocationService().getGasStations();

      for (var station in gasStations) {
        Marker marker = Marker(
          markerId: MarkerId(station['place_id']),
          position: station['location'],
          infoWindow: InfoWindow(title: station['name']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );

        gasStationMarkers.add(marker);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadMarkers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Image.asset(
                  'assets/TiGas.png',
                  fit: BoxFit.contain,
                  height: 140,
                ),
                backgroundColor: Color(0xFF609966),
                elevation: 0,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: _createMarker(),
                      polylines: _polylines,
                      initialCameraPosition: CameraPosition(
                        target: lastBounds != null
                            ? calculateMidPoint(
                                lastBounds!.southwest,
                                lastBounds!.northeast,
                              )
                            : LatLng(10.31306, 123.9128),
                        zoom: 13,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54, blurRadius: 20, spreadRadius: 5)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
