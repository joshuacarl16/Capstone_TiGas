import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

BoxDecoration getGradientDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        Color(0xFF609966),
        Color(0xFF175124),
      ],
    ),
  );
}

TextStyle getEmailTextStyle(double screenHeight) {
  return GoogleFonts.inter(
    fontSize: screenHeight * 0.018,
    color: Colors.grey[700],
  );
}

InputDecoration getEmailInputStyle() {
  return const InputDecoration(
    labelText: 'Email',
    hintText: 'juandelacruz@email.com',
    prefixIcon: Icon(Icons.mail),
    border: OutlineInputBorder(),
  );
}

TextStyle getPasswordTextStyle(double screenHeight) {
  return GoogleFonts.inter(
    fontSize: screenHeight * 0.018,
    color: Colors.grey[700],
  );
}

InputDecoration getPasswordInputStyle() {
  return InputDecoration(
    labelText: 'Password',
    hintText: '*******',
    prefixIcon: Icon(Icons.lock),
    border: OutlineInputBorder(),
  );
}

Text getLoginButtonStyle(double screenHeight) {
  return Text(
    "Sign Up",
    style: GoogleFonts.inter(
      fontSize: screenHeight * 0.018,
      color: Colors.green,
    ),
  );
}

Text getRegisterButtonStyle(double screenHeight) {
  return Text(
    'REGISTER',
    style: GoogleFonts.inter(
      fontSize: screenHeight * 0.025,
      color: Colors.green,
    ),
  );
}