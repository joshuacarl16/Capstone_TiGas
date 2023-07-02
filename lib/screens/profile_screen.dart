import 'package:flutter/material.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  final int selectedTab;
  const ProfilePage({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF609966), // Start color
              Color(0xFF175124), // End color
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedTab: selectedTab,
      ),
    );
  }
}
