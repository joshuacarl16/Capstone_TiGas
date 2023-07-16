import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisScreen extends StatefulWidget {
  @override
  _RegisScreenState createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    displayNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar(context, 'Passwords do not match!');
    } else {
      context.read<FirebaseAuthMethods>().signUpWithEmail(
            email: emailController.text,
            password: passwordController.text,
            context: context,
            displayName: displayNameController.text,
          );
      emailController.clear();
      displayNameController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }

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
              Color(0xFF609966),
              Color(0xFF175124),
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
                                        controller: emailController,
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
                                        controller: displayNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Display Name',
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
                                        controller: passwordController,
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
                                        controller: confirmPasswordController,
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
                                    onPressed: registerUser,
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
