import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tigas_application/styles/styles.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: getGradientDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: screenHeight * 0.70,
                      width: double.infinity,
                      decoration: BoxDecoration(
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
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Log In",
                                    style: GoogleFonts.inter(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
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
                                      // Text("Email",
                                      //     style:
                                      //         getEmailTextStyle(screenHeight)),
                                      SizedBox(height: screenHeight * 0.01),
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        controller: emailController,
                                        decoration: getEmailInputStyle(),
                                        validator: (value) {
                                          if (value!.length == 0) {
                                            return "Email cannot be empty";
                                          }
                                          if (!RegExp(
                                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                              .hasMatch(value)) {
                                            return ("Please enter a valid email");
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          emailController.text = value!;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      // Text("Password",
                                      //     style: getPasswordTextStyle(
                                      //         screenHeight)),
                                      SizedBox(height: screenHeight * 0.01),
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                        ),
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: getPasswordInputStyle(),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Password cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          passwordController.text = value!;
                                        },
                                      ),
                                      SizedBox(height: screenHeight * 0.04),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenHeight * 0.04),
                                            ),
                                            elevation: 3,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.35,
                                              vertical: screenHeight * 0.025,
                                            ),
                                          ),
                                          onPressed: () {
                                            signIn(emailController.text,
                                                passwordController.text);
                                          },
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.045,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don't have an account?",
                                              style: GoogleFonts.inter(
                                                fontSize: screenHeight * 0.018,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            TextButton(
                                              child: getLoginButtonStyle(
                                                  screenHeight),
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisScreen(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: screenHeight * 0.01),
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            signInAsGuest();
                                          },
                                          child: Text(
                                            "Login as Guest",
                                            style: GoogleFonts.inter(
                                              fontSize: screenHeight * 0.018,
                                              color: Colors.green,
                                            ),
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
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -300),
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
      ),
    );
  }

  void route() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavBar(selectedTab: 0),
          ),
        );
      } else {
        var kk = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            var userRole = documentSnapshot.get('role');
            if (userRole == "Caltex" ||
                userRole == "Shell" ||
                userRole == "Jetti" ||
                userRole == "Petron" ||
                userRole == "Phoenix" ||
                userRole == "Seaoil" ||
                userRole == "Total") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBar(selectedTab: 0),
                ),
              );
            }
          } else {
            showSnackBar(context, 'User does not exist');
          }
        });
      }
    }
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        context.read<FirebaseAuthMethods>().isLoggedIn = true;
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(context, 'No user found');
        } else if (e.code == 'wrong-password') {
          showSnackBar(context, 'Wrong password');
        }
      }
    }
  }

  void signInAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      context.read<FirebaseAuthMethods>().isLoggedIn = false;
      route();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'Failed to sign in anonymously: $e');
    }
  }
}
