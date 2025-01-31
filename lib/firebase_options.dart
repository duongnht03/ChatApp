// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCT-bix7a2msPAQksfFxAbERNx3e-uLgQg',
    appId: '1:206063511500:web:256fadfdfd618e74a81f69',
    messagingSenderId: '206063511500',
    projectId: 'chatappflutter-cae27',
    authDomain: 'chatappflutter-cae27.firebaseapp.com',
    storageBucket: 'chatappflutter-cae27.appspot.com',
    measurementId: 'G-FPJL9XYYEJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKOXmDeQSni-6gPFUlYpKZC8oCJvDJepU',
    appId: '1:206063511500:android:58af0f0141a43916a81f69',
    messagingSenderId: '206063511500',
    projectId: 'chatappflutter-cae27',
    storageBucket: 'chatappflutter-cae27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDS-3Ozn8tXJ8xN8uebgpr9KEtPZG3Co8I',
    appId: '1:206063511500:ios:4fa2a755d520de1da81f69',
    messagingSenderId: '206063511500',
    projectId: 'chatappflutter-cae27',
    storageBucket: 'chatappflutter-cae27.appspot.com',
    iosBundleId: 'com.chatapp.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDS-3Ozn8tXJ8xN8uebgpr9KEtPZG3Co8I',
    appId: '1:206063511500:ios:4fa2a755d520de1da81f69',
    messagingSenderId: '206063511500',
    projectId: 'chatappflutter-cae27',
    storageBucket: 'chatappflutter-cae27.appspot.com',
    iosBundleId: 'com.chatapp.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCT-bix7a2msPAQksfFxAbERNx3e-uLgQg',
    appId: '1:206063511500:web:03d6713cb4d33813a81f69',
    messagingSenderId: '206063511500',
    projectId: 'chatappflutter-cae27',
    authDomain: 'chatappflutter-cae27.firebaseapp.com',
    storageBucket: 'chatappflutter-cae27.appspot.com',
    measurementId: 'G-DD32S7BC1L',
  );
}
