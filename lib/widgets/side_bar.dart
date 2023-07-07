import 'package:flutter/material.dart';
import 'package:tigas_application/screens/login_screen.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF609966)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/applogo.jpg'),
                    radius: 40,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Admin Char',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              ],
            ),
          ),
          ..._menuItems
              .map(
                (item) => ListTile(
                  onTap: () {
                    _navigateToPage(context, item);
                  },
                  title: Text(item),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, String item) {
    switch (item) {
      case 'About':
        break;
      case 'Contact':
        break;
      case 'Settings':
        break;
      case 'Sign Out':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}

class SidebarItems extends StatelessWidget {
  const SidebarItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _menuItems
          .map(
            (item) => InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Text(
                  item,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

final List<String> _menuItems = <String>[
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];
