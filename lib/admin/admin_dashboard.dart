// import 'package:flutter/material.dart';
// import 'package:tigas_application/admin_widgets/edit_station.dart';
// // import 'package:image_picker/image_picker.dart';
// import 'package:tigas_application/admin_widgets/post_advertisements.dart';
// import 'package:tigas_application/screens/loading_screen.dart';
// import '../admin_widgets/price_services.dart';

// class MainDashboard extends StatefulWidget {
//   @override
//   _MainDashboardState createState() => _MainDashboardState();
// }

// class _MainDashboardState extends State<MainDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     PostAdvertisement(),
//     ModifyPriceServices(),
//     EditStation()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         backgroundColor: Colors.blue,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Admin Dashboard',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.ad_units),
//               title: Text('Post Advertisement'),
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 0;
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.edit),
//               title: Text('Modify Price & Services'),
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 1;
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.local_gas_station_rounded),
//               title: Text('Edit/Delete Station'),
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 2;
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.arrow_back_ios_new),
//               title: Text('Back to User View'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: ((context) => LoadingScreen()),
//                     ));
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _screens[_selectedIndex],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tigas_application/admin_widgets/edit_station.dart';
import 'package:tigas_application/admin_widgets/post_advertisements.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import '../admin_widgets/price_services.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    PostAdvertisement(),
    ModifyPrice(),
    EditStation()
  ];

  final List<String> _options = [
    'Post Advertisement',
    'Modify Price & Services',
    'Edit/Delete Station',
    'Back to User View'
  ];

  void _onMenuItemSelected(String? value) {
    if (value != null) {
      int index = _options.indexOf(value);
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 3) {
          // Assuming 'Back to User View' is the last option
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => LoadingScreen()),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          DropdownButton<String>(
            underline: Container(),
            icon: Icon(Icons.more_vert, color: Colors.white),
            onChanged: _onMenuItemSelected,
            items: _options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}
