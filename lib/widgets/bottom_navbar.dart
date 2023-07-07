// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tigas_application/screens/ads_screen.dart';
import 'package:tigas_application/screens/camera_screen.dart';
import 'package:tigas_application/screens/homepage_screen.dart';
import 'package:tigas_application/widgets/side_bar.dart';

class NavBar extends StatefulWidget {
  int selectedTab;

  NavBar({Key? key, required this.selectedTab}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NavBarState extends State<NavBar> {
  final List<Widget> _screens = [
    HomePage(selectedTab: 0),
    CameraScreen(),
    CommercialPage(selectedTab: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: DrawerContent(),
      body: _screens[widget.selectedTab],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: widget.selectedTab,
        onTap: (index) {
          setState(() {
            widget.selectedTab = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.local_gas_station),
            title: Text("Home"),
            selectedColor: Color(0xFF175124),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.camera),
            title: Text("Camera"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.flag),
            title: Text("Promos"),
            selectedColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
