import 'package:flutter/material.dart';

// class ContactPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xbc175124), Color(0xff175124)],
//           ),
//         ),
//         child: Column(
//           children: <Widget>[
//             // You might need to adjust the padding for your AppBar.
//             SizedBox(
//               height: MediaQuery.of(context).padding.top,
//             ),
//             Image.asset(
//               "assets/Tigas.png",
//               width: 115,
//               height: 37,
//             ),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text(
//                         "Contacts",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         children: const [
//                           DeveloperDetailWidget(
//                             name: 'Rupal, Franz Adrian G.',
//                             email: 'franzrupal@gmail.com',
//                             imagePath: 'assets/franzpng.png',
//                           ),
//                           DeveloperDetailWidget(
//                             name: 'Arceño, Joshua Carl M.',
//                             email: 'joshuacarl16@gmail.com',
//                             imagePath: 'assets/carlpng.png',
//                           ),
//                           DeveloperDetailWidget(
//                             name: 'Palalay, Julius D.',
//                             email: 'juljulducante@gmail.com',
//                             imagePath: 'assets/juliuspng.png',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DeveloperDetailWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const DeveloperDetailWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 16), // Space between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), // The menu icon
          onPressed: () {
            // Logic to open drawer or sidebar
          },
        ),
        backgroundColor: Colors.transparent, // Makes the AppBar transparent
        elevation: 0, // Removes shadow from the AppBar
      ),
      extendBodyBehindAppBar: true, // Allows the body to be behind the AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xbc175124), Color(0xff175124)],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 56, // Add AppBar height
              ),
              child: Center(
                child: Image.asset(
                  "assets/Tigas.png",
                  width: 150, // Increase the width for a bigger logo
                  height: 100, // Increase the height accordingly
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Contacts",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: const [
                          DeveloperDetailWidget(
                            name: 'Rupal, Franz Adrian G.',
                            email: 'franzrupal@gmail.com',
                            imagePath: 'assets/franzpng.png',
                          ),
                          DeveloperDetailWidget(
                            name: 'Arceño, Joshua Carl M.',
                            email: 'joshuacarl16@gmail.com',
                            imagePath: 'assets/carlpng.png',
                          ),
                          DeveloperDetailWidget(
                            name: 'Palalay, Julius D.',
                            email: 'juljulducante@gmail.com',
                            imagePath: 'assets/juliuspng.png',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
