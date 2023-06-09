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
    apiKey: 'AIzaSyAa_GkArjzq5rWG_P9LjmCM-5QgsWJIS6E',
    appId: '1:946556306244:web:108fcb6633fbcfdb520d11',
    messagingSenderId: '946556306244',
    projectId: 'apt293-4f9ac',
    authDomain: 'apt293-4f9ac.firebaseapp.com',
    databaseURL: 'https://apt293-4f9ac-default-rtdb.firebaseio.com',
    storageBucket: 'apt293-4f9ac.appspot.com',
    measurementId: 'G-VBXX50YH45',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6kWKsNxLcnQOWsEfKyIMppnyy_YTI7VQ',
    appId: '1:946556306244:android:d78655e5ddd417f2520d11',
    messagingSenderId: '946556306244',
    projectId: 'apt293-4f9ac',
    databaseURL: 'https://apt293-4f9ac-default-rtdb.firebaseio.com',
    storageBucket: 'apt293-4f9ac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCD6FZQPERCkLRWqCC4kgCbC_H-gTEShxU',
    appId: '1:946556306244:ios:bfc4308c96f7fe43520d11',
    messagingSenderId: '946556306244',
    projectId: 'apt293-4f9ac',
    databaseURL: 'https://apt293-4f9ac-default-rtdb.firebaseio.com',
    storageBucket: 'apt293-4f9ac.appspot.com',
    iosClientId:
        '946556306244-d9s9fie7hamb9i7cqbc68olnfavmjf2n.apps.googleusercontent.com',
    iosBundleId: 'com.example.att2Flutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCD6FZQPERCkLRWqCC4kgCbC_H-gTEShxU',
    appId: '1:946556306244:ios:bfc4308c96f7fe43520d11',
    messagingSenderId: '946556306244',
    projectId: 'apt293-4f9ac',
    databaseURL: 'https://apt293-4f9ac-default-rtdb.firebaseio.com',
    storageBucket: 'apt293-4f9ac.appspot.com',
    iosClientId:
        '946556306244-d9s9fie7hamb9i7cqbc68olnfavmjf2n.apps.googleusercontent.com',
    iosBundleId: 'com.example.att2Flutter',
  );
}
