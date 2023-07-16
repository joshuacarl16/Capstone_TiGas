// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDEKK8d_j9x3to4ClXvMKRmJRyHubpagPE',
    appId: '1:878287150120:web:a965330b9f279ff075291d',
    messagingSenderId: '878287150120',
    projectId: 'tigas-2939a',
    authDomain: 'tigas-2939a.firebaseapp.com',
    storageBucket: 'tigas-2939a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2eOy3eCX53Ee1nk3Uk7OWIOV2KXoFDIU',
    appId: '1:878287150120:android:6bf24e4e190f40de75291d',
    messagingSenderId: '878287150120',
    projectId: 'tigas-2939a',
    storageBucket: 'tigas-2939a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsIFufpn8n4JYeZVxNVDD8cbMQZ06X8IY',
    appId: '1:878287150120:ios:0c818d5d7e84e8d975291d',
    messagingSenderId: '878287150120',
    projectId: 'tigas-2939a',
    storageBucket: 'tigas-2939a.appspot.com',
    iosClientId: '878287150120-5b36t4c66qa0g33fo1j2en7r694q92u0.apps.googleusercontent.com',
    iosBundleId: 'com.example.tigasApplication',
  );
}
