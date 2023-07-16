import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../admin_widgets/post_advertisments.dart';
import '../admin_widgets/price_services.dart';

// class AdminDashboard extends StatefulWidget {
//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final TextEditingController _adController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
  
//   String _selectedGasType = 'Gasoline'; // Default selection
//   final Map<String, String> _gasPrices = {
//     'Gasoline': '',
//     'Diesel': ''
//   }; // Default prices

//   Map<String, bool> services = {
//     'Oil': false,
//     'Water': false,
//     'Air': false,
//     'CR': false,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       backgroundColor: Color(0xFF609966), // Add the background color here
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // Advertisement Section
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Make container background white
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(
//                    color:Color(0xFF175124), // Change border color to blue
//                      width: 3.0),
//                 ),
//                 child: Column(
//                   children: [
//                     Text('Post an Advertisement'),
//                     TextFormField(
//                       controller: _adController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         labelText: 'Advertisement Text',
//                       ),
//                     ),

//                     SizedBox(height: 10,),
                    
//                     ElevatedButton(
//                       onPressed: () async {
//                         var pickedImage = await ImagePicker()
//                             .getImage(source: ImageSource.gallery);
//                         if (pickedImage != null) {
//                           // Your code to upload the image and text to the server
//                         }
//                       },
//                       child: Text('Pick Image and Upload'),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20.0),

//               // Gas Price Section
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Make container background white
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(
//                    color: Color(0xFF175124), // Change border color to blue
//                    width: 3.0),
//                 ),
//                 child: Column(
//                   children: [
//                     Text('Modify Gas Price'),
//                     DropdownButton<String>(
//                       value: _selectedGasType,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedGasType = newValue!;
//                         });
//                       },
//                       items: <String>['Gasoline', 'Diesel']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     TextFormField(
//                       controller: _priceController,
//                       decoration: InputDecoration(
//                         labelText: 'New Gas Price',
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),

//                     SizedBox(height: 10,),

//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           // Your code to update the gas price in the server
//                           // Use _selectedGasType for the type of gas
//                           _gasPrices[_selectedGasType] = _priceController.text;
//                         });
//                       },
//                       child: Text('Update Price'),
//                     ),
//                     Text('Gasoline Price: ₱${_gasPrices['Gasoline']}'),
//                     Text('Diesel Price: ₱${_gasPrices['Diesel']}'),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20.0),

//               // Service Availability Section
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Make container background white
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(
//                     color: Color(0xFF175124), // Change border color to blue
//                     width: 3.0),
//                 ),
//                 child: Column(
//                   children: [
//                     Text('Service Availability'),
//                     Column(
//                       children: services.keys.map((String key) {
//                         return CheckboxListTile(
//                           title: Text(key),
//                           value: services[key],
//                           onChanged: (bool? value) {
//                             setState(() {
//                               services[key] = value!;
//                               // Your code to update the service availability status in the server
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0; // Keep track of the selected index

  // List of widget screens
  final List<Widget> _screens = [
    PostAdvertisement(),
    ModifyPriceServices(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}


