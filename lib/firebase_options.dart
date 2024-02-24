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
    apiKey: 'AIzaSyAzf3UWpCgnFHHpYOTnBskWT4Cf3WXe06E',
    appId: '1:79506262265:web:e9ae2e9126e27324ac7a28',
    messagingSenderId: '79506262265',
    projectId: 'hungerhaven-27983',
    authDomain: 'hungerhaven-27983.firebaseapp.com',
    storageBucket: 'hungerhaven-27983.appspot.com',
    measurementId: 'G-M6SH2J5N2L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu9lXG3oqFYRX_nn9fcDiGkG1cXnLuy-E',
    appId: '1:79506262265:android:bef1d762b2c2f2e0ac7a28',
    messagingSenderId: '79506262265',
    projectId: 'hungerhaven-27983',
    storageBucket: 'hungerhaven-27983.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyJ44wnJovrR7t82a0I6iroZytpYnPbis',
    appId: '1:79506262265:ios:958919234d50481bac7a28',
    messagingSenderId: '79506262265',
    projectId: 'hungerhaven-27983',
    storageBucket: 'hungerhaven-27983.appspot.com',
    iosBundleId: 'com.hungerheaven.restaurant',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyJ44wnJovrR7t82a0I6iroZytpYnPbis',
    appId: '1:79506262265:ios:2705b3c4d3fb02b0ac7a28',
    messagingSenderId: '79506262265',
    projectId: 'hungerhaven-27983',
    storageBucket: 'hungerhaven-27983.appspot.com',
    iosBundleId: 'com.hungerheaven.restaurant.RunnerTests',
  );
}