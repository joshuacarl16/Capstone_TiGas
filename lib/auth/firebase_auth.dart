import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  late final DatabaseReference databaseRef;

  FirebaseAuthMethods(this._auth);
  // final FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://tigas-2939a-default-rtdb.asia-southeast1.firebasedatabase.app/");
  // databaseRef = database.ref();
  User get user => _auth.currentUser!;

  //state
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  //email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String displayName,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(displayName);
      showSnackBar(context, 'Account registration successful');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //email login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //sign out
  Future<void> signOut(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(),
      ),
    );
  }
}
