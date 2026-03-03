// firebase_options.dart
// Auto-configured with real Firebase project: scoresync-48ebe

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBh2OohmMF3lBBhYiO0P7JxbUFsJ0CXfI0',
    appId: '1:428549114421:web:bea92ad490462287527f7c',
    messagingSenderId: '428549114421',
    projectId: 'scoresync-48ebe',
    storageBucket: 'scoresync-48ebe.firebasestorage.app',
    authDomain: 'scoresync-48ebe.firebaseapp.com',
    measurementId: 'G-DLG4LVVL8L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBh2OohmMF3lBBhYiO0P7JxbUFsJ0CXfI0',
    appId: '1:428549114421:android:bea92ad490462287527f7c',
    messagingSenderId: '428549114421',
    projectId: 'scoresync-48ebe',
    storageBucket: 'scoresync-48ebe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBh2OohmMF3lBBhYiO0P7JxbUFsJ0CXfI0',
    appId: '1:428549114421:ios:bea92ad490462287527f7c',
    messagingSenderId: '428549114421',
    projectId: 'scoresync-48ebe',
    storageBucket: 'scoresync-48ebe.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
