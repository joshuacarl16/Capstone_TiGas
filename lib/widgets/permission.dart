// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationAccessScreen extends StatefulWidget {
//   @override
//   _LocationAccessScreenState createState() => _LocationAccessScreenState();
// }

// class _LocationAccessScreenState extends State<LocationAccessScreen> {
//   GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//   }

//   Future<void> _requestLocationPermission() async {
//     LocationPermission permission;

//     bool isLocationServiceEnabled =
//         await _geolocator.isLocationServiceEnabled();
//     if (!isLocationServiceEnabled) {
//       // Handle case when location service is not enabled
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Location Service Disabled'),
//           content: Text('Please enable location service to proceed.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     permission = await _geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocator.requestPermission();

//       if (permission == LocationPermission.denied) {
//         // Handle case when user denies location permission
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Location Permission Denied'),
//             content: Text('Please grant location permission to proceed.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Handle case when user denies location permission permanently
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Location Permission Denied'),
//           content: Text(
//               'You have denied location permission permanently. Please go to app settings to enable it.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     // Location permission granted, proceed with accessing user's location
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position;
//     try {
//       position = await _geolocator.getCurrentPosition(
//           // desiredAccuracy: LocationAccuracy.high,
//           );
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       // Handle case when unable to get user's location
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Location Error'),
//           content: Text('Unable to retrieve user\'s location.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     // Do something with the user's current location
//     print('Latitude: ${position.latitude}');
//     print('Longitude: ${position.longitude}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Access'),
//       ),
//       body: Center(
//         child: _currentPosition != null
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Latitude: ${_currentPosition!.latitude}',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     'Longitude: ${_currentPosition!.longitude}',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               )
//             : Text('Requesting location access...'),
//       ),
//     );
//   }
// }
