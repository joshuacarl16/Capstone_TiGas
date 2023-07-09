import 'package:flutter/material.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'screens/homepage_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TiGas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF609966)),
        ),
        home: HomePage(
          selectedTab: 0,
        ));
  }
}
