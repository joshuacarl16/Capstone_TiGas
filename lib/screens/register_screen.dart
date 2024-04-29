import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/styles/styles.dart';
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

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var options = [
    'User',
    'Admin',
  ];
  var role = "User";

  @override
  void dispose() {
    emailController.dispose();
    displayNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Form(
                          key: _formkey,
                          child: Container(
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
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Register",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                            onChanged: (value) {},
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                          SizedBox(height: screenHeight * 0.03),
                                          TextFormField(
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
                                          TextFormField(
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
                                            validator: (value) {
                                              RegExp regex =
                                                  new RegExp(r'^.{6,}$');
                                              if (value!.isEmpty) {
                                                return "Password cannot be empty";
                                              }
                                              if (!regex.hasMatch(value)) {
                                                return ("please enter valid password (min. 6 characters)");
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {},
                                          ),
                                          SizedBox(height: screenHeight * 0.03),
                                          TextFormField(
                                            style: TextStyle(
                                              fontSize: screenHeight * 0.02,
                                            ),
                                            controller:
                                                confirmPasswordController,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              labelText: 'Confirm Password',
                                              prefixIcon: Icon(Icons.lock),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (confirmPasswordController
                                                      .text !=
                                                  passwordController.text) {
                                                return "Password did not match";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {},
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
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
                                          signUp(
                                              emailController.text,
                                              passwordController.text,
                                              displayNameController.text,
                                              role);
                                        },
                                        child: getRegisterButtonStyle(
                                            screenHeight),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                builder: (context) =>
                                                    LoginScreen(),
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

  void signUp(
      String email, String password, String displayName, String role) async {
    CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, displayName, role)})
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String email, String displayName, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': emailController.text,
      'displayname': displayName,
      'role': role
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    showSnackBar(context, 'Successfully registered');
  }
}
