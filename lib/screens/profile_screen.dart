import 'package:flutter/material.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'package:tigas_application/styles/styles.dart';

class ProfilePage extends StatelessWidget {
  final int selectedTab;
  const ProfilePage({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getGradientDecoration(),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => LoginScreen()),
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}
