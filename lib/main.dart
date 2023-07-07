import 'package:flutter/material.dart';
import 'package:tigas_application/screens/ads_screen.dart';
import 'package:tigas_application/screens/homepage_screen.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:tigas_application/widgets/side_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TiGas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: LoadingScreen());
  }
}
