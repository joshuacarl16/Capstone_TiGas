import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:image/image.dart' as img;
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/models/user_location.dart';
import 'package:tigas_application/screens/set_location.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:tigas_application/widgets/rate_station.dart';

class HPMap extends StatefulWidget {
  const HPMap({Key? key, required this.destination, required this.selectedTab})
      : super(key: key);
  final int selectedTab;
  final String destination;

  @override
  State<HPMap> createState() => HPMapState();
}

class HPMapState extends State<HPMap> {
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

  bool userLocationSet = false;
  LatLng? userSelectedLocation;
  Position? currentUserPosition;

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

    final markerImages = ['assets/station.png', 'assets/currentloc.png'];

    for (var i = 0; i < markerImages.length; i++) {
      final byteData = await rootBundle.load(markerImages[i]);
      Uint8List resizedBytes;
      if (i == 0) {
        resizedBytes =
            await resizeImage(byteData.buffer.asUint8List(), 100, 100);
        customIcons.add(BitmapDescriptor.fromBytes(resizedBytes));
      } else if (i == 1) {
        resizedBytes = await resizeImage(byteData.buffer.asUint8List(), 120,
            120); // new size for current location icon
        currentLocationIcon = BitmapDescriptor.fromBytes(resizedBytes);
      }
    }
  }

  Future<void> fetchAndLoadGasStations() async {
    List<Map<String, dynamic>> stations =
        await LocationService().getGasStations();
    List<Marker> stationMarkers = [];

    for (var station in stations) {
      Marker stationMarker = Marker(
        markerId: MarkerId(station['place_id']),
        position: station['location'],
        infoWindow: InfoWindow(
          title: station['name'],
          snippet: station['distance'].toString(),
        ),
        icon: customIcons[0],
      );
      stationMarkers.add(stationMarker);
    }

    setState(() {
      gasStationMarkers = stationMarkers;
      areStationsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.destination != null) {
        _station = getRoute(widget.destination);
      }
    });
    loadMarkers();
    fetchAndLoadGasStations();
  }

  Set<Marker> _createMarker() {
    var markers = <Marker>{};

    markers.addAll(gasStationMarkers);
    if (currentLocationMarker != null) {
      markers.add(currentLocationMarker!);
    }
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

  Future<void> fetchCurrentUserLocation() async {
    // Fetch location only if not set before
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
    UserLocation().updateLocation(position.latitude, position.longitude);
    _startLocation = LatLng(position.latitude, position.longitude);

    // Set the current location marker
    setCurrentLocationMarker(position.latitude, position.longitude);
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

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
      northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
    );

    // Set constant zoom level
    const double zoomLevel = 13.0;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), zoomLevel),
    );

    setCurrentLocationMarker(lat, lng);
    setState(() {});
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
            color: Colors.purple[400]!,
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
            body: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  markers: _createMarker(),
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: _startLocation ??
                        LatLng(10.31306,
                            123.9128), // Default location if _startLocation is null
                    zoom: 13,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );
                      currentUserPosition = position;
                      UserLocation().updateLocation(
                          position.latitude, position.longitude);
                      _goToPlace(
                        position.latitude,
                        position.longitude,
                        {'lat': position.latitude, 'lng': position.longitude},
                        {'lat': position.latitude, 'lng': position.longitude},
                      );
                      setState(() {});
                    },
                    child: Icon(Icons.my_location),
                    backgroundColor: Color(0xFF609966),
                  ),
                ),
                Positioned(
                  bottom: 84.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SetLocationScreen()),
                        ),
                      );
                      if (selectedLocation != null) {
                        List<Location> locations =
                            await locationFromAddress(selectedLocation);
                        if (locations.isNotEmpty) {
                          Location location = locations.first;
                          double lat = location.latitude;
                          double lng = location.longitude;
                          setState(() {
                            userSelectedLocation = LatLng(lat, lng);
                            location = location;
                            userLocationSet = true;
                          });

                          _goToPlace(lat, lng, {'lat': lat, 'lng': lng},
                              {'lat': lat, 'lng': lng});
                        }
                      }
                    },
                    child: Icon(Icons.pin_drop_outlined),
                    backgroundColor: Color.fromARGB(255, 8, 146, 238),
                  ),
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
