import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tigas_application/styles/styles.dart';
import 'package:tigas_application/screens/login_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Log In",
                                style: GoogleFonts.inter(
                                  fontSize: screenHeight * 0.06,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email",
                                      style: getEmailTextStyle(screenHeight)),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextField(
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                    ),
                                    controller: emailController,
                                    decoration: getEmailInputStyle(),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text("Password",
                                      style:
                                          getPasswordTextStyle(screenHeight)),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextField(
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                    ),
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: getPasswordInputStyle(),
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
                                  SizedBox(height: screenHeight * 0.05),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                        );
                                      },
                                      child: Text(
                                        "Login as User",
                                        style: GoogleFonts.inter(
                                          fontSize: screenHeight * 0.025,
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
