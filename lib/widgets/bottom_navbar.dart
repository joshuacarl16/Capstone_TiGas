// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tigas_application/screens/ads_screen.dart';
import 'package:tigas_application/screens/homepage_screen.dart';
import 'package:tigas_application/screens/map_screen.dart';
import 'package:tigas_application/widgets/side_bar.dart';
import 'package:tigas_application/widgets/station_selector.dart';

class NavBar extends StatefulWidget {
  int selectedTab;

  NavBar({Key? key, required this.selectedTab}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NavBarState extends State<NavBar> {
  final homePageScrollController = ScrollController();
  final commercialPageScrollController = ScrollController();
  late final List<Widget> screens = [
    HPMap(
      selectedTab: 0,
      destination: '',
    ),
    HomePage(selectedTab: 2, scrollController: homePageScrollController),
    CommercialPage(
        selectedTab: 3, scrollController: commercialPageScrollController),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    homePageScrollController.dispose();
    commercialPageScrollController.dispose();
    super.dispose();
  }

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
      ),
      drawer: DrawerContent(),
      body: screens[widget.selectedTab],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: widget.selectedTab,
        onTap: (index) {
          if (widget.selectedTab == index) {
            switch (index) {
              case 0:
                homePageScrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
                break;
              case 1:
                homePageScrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
                break;
              case 2:
                commercialPageScrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
                break;
            }
          } else {
            setState(() {
              widget.selectedTab = index;
            });
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.map),
            title: Text("Map"),
            selectedColor: Color(0xFF175124),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.local_gas_station),
            title: Text("List"),
            selectedColor: Color(0xFF175124),
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
