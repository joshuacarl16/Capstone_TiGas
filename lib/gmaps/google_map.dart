import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:image/image.dart' as img;
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/models/user_location.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:tigas_application/widgets/rate_station.dart';

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
  Marker? currentLocationMarker;
  Marker? destinationMarker;
  BitmapDescriptor? currentLocationIcon;
  List<Marker> gasStationMarkers = [];
  Future<Station>? _station;
  LatLng? _startLocation;
  bool areStationsVisible = false;

  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;

  showRatingDialog(BuildContext context, int stationId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: RateDialog(stationId: stationId),
        );
      },
    );
  }

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

    final markerImages = ['assets/stationlogo.png', 'assets/greencircle.png'];

    for (var i = 0; i < markerImages.length; i++) {
      final byteData = await rootBundle.load(markerImages[i]);
      Uint8List resizedBytes;
      if (i == 0) {
        resizedBytes = await resizeImage(byteData.buffer.asUint8List(), 40, 40);
        customIcons.add(BitmapDescriptor.fromBytes(resizedBytes));
      } else if (i == 1) {
        resizedBytes = await resizeImage(byteData.buffer.asUint8List(), 80,
            80); // new size for current location icon
        currentLocationIcon = BitmapDescriptor.fromBytes(resizedBytes);
      }
    }
  }

  Future<void> fetchAndLoadGasStations() async {
    if (areStationsVisible) {
      setState(() {
        gasStationMarkers = [];
        areStationsVisible = false;
      });
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  "Loading Stations",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );

    List<Map<String, dynamic>> stations =
        await LocationService().getGasStations();
    List<Marker> stationMarkers = [];

    for (var station in stations) {
      Marker stationMarker = Marker(
        markerId: MarkerId(station['place_id']),
        position: station['location'],
        infoWindow: InfoWindow(
            title: station['name'], snippet: station['distance'].toString()),
        icon: customIcons[0],
      );
      stationMarkers.add(stationMarker);
    }

    Navigator.pop(context);

    setState(() {
      gasStationMarkers = stationMarkers;
      areStationsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _station = getRoute(widget.destination);
    });
    loadMarkers();
  }

  Set<Marker> _createMarker() {
    var markers = <Marker>{};

    markers.addAll(gasStationMarkers);
    if (currentLocationMarker != null) {
      markers.add(currentLocationMarker!);
    }
    if (destinationMarker != null) {
      markers.add(destinationMarker!);
    }
    return markers;
  }

  void setDestinationMarker(double latitude, double longitude, String title) {
    destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: title),
      icon: BitmapDescriptor.defaultMarker,
    );
  }

  void setCurrentLocationMarker(double latitude, double longitude) {
    currentLocationMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: currentLocationIcon ?? BitmapDescriptor.defaultMarker,
    );
  }

  Future<Station> getRoute(String stationId) async {
    Station station = await LocationService().getGasStation(stationId);

    setCurrentLocationMarker(
        UserLocation().latitude!, UserLocation().longitude!);

    setDestinationMarker(station.latitude, station.longitude, station.name);

    String currentPos =
        "${UserLocation().latitude}, ${UserLocation().longitude}";

    String destination = "${station.latitude}, ${station.longitude}";

    var directions =
        await LocationService().getDirections(currentPos, destination);

    _startLocation = LatLng(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
    );

    _goToPlace(
      _startLocation!.latitude,
      _startLocation!.longitude,
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    _setPolyline(directions['polyline_decoded']);

    return station;
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;

    lastBounds = LatLngBounds(
      southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
      northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
    );

    // Apply padding as needed
    final double screenPadding = MediaQuery.of(context).size.width * 0.10;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(lastBounds!, screenPadding),
    );
  }

  double calculateZoomLevel(LatLngBounds bounds) {
    final double maxZoom = 15.0;
    final double minZoom = 4.0;

    double distance = Geolocator.distanceBetween(
      bounds.southwest.latitude,
      bounds.southwest.longitude,
      bounds.northeast.latitude,
      bounds.northeast.longitude,
    );

    double distanceInKilometers = distance / 1000;

    double zoomLevel = maxZoom - (distanceInKilometers / 10);

    if (zoomLevel < minZoom) {
      return minZoom;
    } else if (zoomLevel > maxZoom) {
      return maxZoom;
    } else {
      return zoomLevel;
    }
  }

  void _setPolyline(List<PointLatLng> points) {
    String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    setState(() {
      _polylines.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 6,
            color: Colors.green[300]!,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Station>(
      future: _station,
      builder: (BuildContext context, AsyncSnapshot<Station> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset(
                'assets/TiGas.png',
                fit: BoxFit.contain,
                height: 140,
              ),
              backgroundColor: Color(0xFF609966),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NavBar(selectedTab: 0),
                    ),
                  );
                  showRatingDialog(context, snapshot.data!.id);
                },
              ),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  markers: _createMarker(),
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: _startLocation ?? LatLng(10.31306, 123.9128),
                    zoom: 13,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
              body: Center(
                  child:
                      CircularProgressIndicator())); // or any other placeholder widget
        }
      },
    );
  }
}
