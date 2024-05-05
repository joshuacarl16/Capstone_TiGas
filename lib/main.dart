import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/firebase_options.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'high_importance_channel',
            channelKey: 'high_importance_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            playSound: true,
            criticalAlerts: true)
      ],
      debug: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  runApp(ChangeNotifierProvider(
    create: (context) => StationProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null),
        Provider<FirebaseFirestore>(
          create: (_) => firestore,
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => StationProvider(),
        child: MaterialApp(
            title: 'TiGas',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF609966)),
            ),
            home: LoadingScreen()),
      ),
    );
  }
}
