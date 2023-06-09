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
        return macos;
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
    apiKey: 'AIzaSyDalPXsHSBKX7D4rYUfaUK5rmBKTqpVulM',
    appId: '1:307288245777:web:62f4bef2d9fbfa7f7c93b0',
    messagingSenderId: '307288245777',
    projectId: 'sewagerobot-77461',
    authDomain: 'sewagerobot-77461.firebaseapp.com',
    storageBucket: 'sewagerobot-77461.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRPbx2jwmdDhg55Ism2UsRP0yPcIupqcA',
    appId: '1:307288245777:android:54680500404e12097c93b0',
    messagingSenderId: '307288245777',
    projectId: 'sewagerobot-77461',
    storageBucket: 'sewagerobot-77461.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCk--g4dF_vB4LVpMQ4bUAXPEhmOlGphWk',
    appId: '1:307288245777:ios:4b6eced9e544aeb57c93b0',
    messagingSenderId: '307288245777',
    projectId: 'sewagerobot-77461',
    storageBucket: 'sewagerobot-77461.appspot.com',
    iosClientId: '307288245777-gqsu74d9no5p1n759pe8nmdanp0acros.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCk--g4dF_vB4LVpMQ4bUAXPEhmOlGphWk',
    appId: '1:307288245777:ios:4b6eced9e544aeb57c93b0',
    messagingSenderId: '307288245777',
    projectId: 'sewagerobot-77461',
    storageBucket: 'sewagerobot-77461.appspot.com',
    iosClientId: '307288245777-gqsu74d9no5p1n759pe8nmdanp0acros.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientApp',
  );
}
