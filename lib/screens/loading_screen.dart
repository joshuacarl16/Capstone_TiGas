// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'homepage_screen.dart';

// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     Timer(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(selectedTab: 0),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.center,
//             colors: [
//               Color(0xFF609966), // Start color
//               Color(0xFF175124), // End color
//             ],
//           ),
//         ),
//         child: Center(
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               Container(
//                 width: 300,
//                 height: 300,
//                 child: Image.asset('assets/TiGas.png'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 2),
        ),
      );
    });
  }

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
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/TiGas.png'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
