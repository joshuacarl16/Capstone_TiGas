import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF609966),
              Color(0xFF175124),
            ],
          ),
        ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log In",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.inter(
                                      fontSize: screenHeight * 0.018,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextField(
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                    ),
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'somethingsomething@gmail.com',
                                      prefixIcon: Icon(Icons.mail),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    "Password",
                                    style: GoogleFonts.inter(
                                      fontSize: screenHeight * 0.018,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextField(
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                    ),
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: '*******',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
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
                                          horizontal: screenWidth * 0.35,
                                          vertical: screenHeight * 0.025,
                                        ),
                                      ),
                                      onPressed: loginUser,
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.025,
                                        ),
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
                                          child: Text(
                                            "Sign Up",
                                            style: GoogleFonts.inter(
                                              fontSize: screenHeight * 0.018,
                                              color: Colors.green,
                                            ),
                                          ),
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
                                ],
                              ),
                            ),
                          ],
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
}
