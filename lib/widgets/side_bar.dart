import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/admin/admin_dashboardtest.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';

import 'package:tigas_application/screens/contacts_screen.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF609966)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/applogo.jpg'),
                    radius: 40,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName ?? '',
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
      case 'Admin':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        break;
      case 'About':
        break;
      case 'Contact':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ContactPage()));
        break;
      case 'Settings':
        break;
      case 'Sign Out':
        context.read<FirebaseAuthMethods>().signOut(context);
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
  'Admin',
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];
