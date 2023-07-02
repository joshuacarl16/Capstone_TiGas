import 'package:flutter/material.dart';
import 'package:tigas_application/screens/camera_screen.dart';
import 'package:tigas_application/screens/homepage_screen.dart';
import 'package:tigas_application/screens/profile_screen.dart';

class NavBar extends StatefulWidget {
  final int selectedTab;

  const NavBar({super.key, required this.selectedTab});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> _screens = [
    HomePage(
      selectedTab: 0,
    ),
    CameraScreen(),
    ProfilePage(
      selectedTab: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navBarItem(Icons.local_gas_station, 0),
          navBarItem(Icons.camera, 1),
          navBarItem(Icons.account_circle_outlined, 2),
        ],
      ),
    );
  }

  Widget navBarItem(IconData icon, int index) {
    final isSelected = widget.selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _screens[index]),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF175124) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
