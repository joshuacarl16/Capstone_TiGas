import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tigas_application/admin/admin_dashboard.dart';
import 'package:tigas_application/auth/firebase_auth.dart';
import 'package:tigas_application/firebase_options.dart';
import 'package:tigas_application/notification/push_notif.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/screens/loading_screen.dart';
import 'package:tigas_application/screens/login_screen.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';


final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("notification received");
  }
}

void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
    if (message.notification != null)  {
      print("Background Notif Tapped");
      navigatorKey.currentState!.pushNamed(LoadingScreen() as String);
    }
  });
  PushNotifications.initNotif();
  // only initialize if platform is not web
  if (!kIsWeb) {
    PushNotifications.localNotifInit();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print("Received foreground message");
    if(message.notification !=  null) {
      if (kIsWeb) {
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            );
      }
    }
  });
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed(LoadingScreen() as String);
    });
  }
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
          navigatorKey: navigatorKey,
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
