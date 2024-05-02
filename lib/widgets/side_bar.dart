import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/screens/contacts_screen.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final displayName = (snapshot.data?.data()
                  as Map<String, dynamic>?)?['displayname'] ??
              'Guest';

          return ListView(
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
                      displayName,
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
          );
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, String item) {
    switch (item) {
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
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];
