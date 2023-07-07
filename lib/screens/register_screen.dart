import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF609966), // Start color
              Color(0xFF175124), // End color
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.80,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.05,
                              screenHeight * 0.025,
                              screenWidth * 0.05,
                              screenHeight * 0.025,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Register",
                                  style: GoogleFonts.inter(
                                    fontSize: screenHeight * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    screenWidth * 0.03,
                                    0,
                                    0,
                                    screenHeight * 0.02,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          hintText: 'example@gmail.com',
                                          prefixIcon: Icon(Icons.mail),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                      TextField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          hintText: 'farggaming',
                                          prefixIcon: Icon(
                                              Icons.account_circle_rounded),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                      TextField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: Icon(Icons.lock),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                      TextField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          prefixIcon: Icon(Icons.lock),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenHeight * 0.04),
                                      ),
                                      elevation: 3,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.28,
                                        vertical: screenHeight * 0.025,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    screenWidth * 0.045,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: GoogleFonts.inter(
                                          fontSize: screenHeight * 0.02,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Login here",
                                          style: GoogleFonts.inter(
                                            fontSize: screenHeight * 0.02,
                                            color: Colors.green,
                                          ),
                                        ),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -280),
                          child: Image.asset(
                            'assets/TiGas.png',
                            scale: 1.5,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class RegisScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     Orientation orientation = MediaQuery.of(context).orientation;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.center,
//             colors: [
//               Color(0xFF609966), // Start color
//               Color(0xFF175124), // End color
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           // padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
//           // shrinkWrap: true,
//           // reverse: true,
//           children: [
//             Stack(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           height: 535,
//                           width: double.infinity,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(40),
//                               topRight: Radius.circular(40),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Register",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       TextField(
//                                         decoration: InputDecoration(
//                                           labelText: 'Email Address',
//                                           hintText: 'example@gmail.com',
//                                           prefixIcon: Icon(Icons.mail),
//                                           border: OutlineInputBorder(),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         decoration: InputDecoration(
//                                           labelText: 'Username',
//                                           hintText: 'farggaming',
//                                           prefixIcon: Icon(
//                                               Icons.account_circle_rounded),
//                                           border: OutlineInputBorder(),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         obscureText: true,
//                                         decoration: InputDecoration(
//                                           labelText: 'Password',
//                                           prefixIcon: Icon(Icons.lock),
//                                           border: OutlineInputBorder(),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         obscureText: true,
//                                         decoration: InputDecoration(
//                                           labelText: 'Confirm Password',
//                                           prefixIcon: Icon(Icons.lock),
//                                           border: OutlineInputBorder(),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Center(
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(30.0),
//                                           ),
//                                           elevation: 3,
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 128, vertical: 20)),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text('REGISTER')),
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(35, 0, 0, 0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         "Already have an account?",
//                                         style: GoogleFonts.inter(
//                                           fontSize: 15,
//                                           color: Colors.grey[700],
//                                         ),
//                                       ),
//                                       TextButton(
//                                         child: Text(
//                                           "Login here",
//                                           style: GoogleFonts.inter(
//                                             fontSize: 15,
//                                             color: Colors.green,
//                                           ),
//                                         ),
//                                         onPressed: () => Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LoginScreen()),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Transform.translate(
//                           offset: const Offset(0, -300),
//                           child: Image.asset(
//                             'assets/TiGas.png',
//                             scale: 1.5,
//                             width: double.infinity,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
