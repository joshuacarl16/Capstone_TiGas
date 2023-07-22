import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../admin_widgets/post_advertisments.dart';
=======
import 'package:image_picker/image_picker.dart';
import 'package:tigas_application/admin_widgets/post_advertisements.dart';
import 'package:tigas_application/screens/loading_screen.dart';

>>>>>>> fea328c5f24b8026929f6ecc6f8932351d81b6ea
import '../admin_widgets/price_services.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PostAdvertisement(),
    ModifyPriceServices(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.ad_units),
              title: Text('Post Advertisement'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modify Price & Services'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back_ios_new),
              title: Text('Back to User View'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => LoadingScreen()),
                    ));
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
