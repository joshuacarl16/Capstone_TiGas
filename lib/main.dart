import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';
import 'package:tigas_application/admin_widgets/add_station.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/firebase_options.dart';
import 'package:tigas_application/screens/homepage_screen.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null),
      ],
      child: MaterialApp(
          title: 'TiGas',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF609966)),
          ),
          home: LoadingScreen()),
    );
  }
}

class IsAuthenticated extends StatelessWidget {
  const IsAuthenticated({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return NavBar(selectedTab: 0);
    }
    return LoginScreen();
  }
}
