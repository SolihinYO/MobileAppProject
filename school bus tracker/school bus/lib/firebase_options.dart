import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'MASUKKAN_API_KEY_DARI_FIREBASE_CONSOLE',
    appId: 'MASUKKAN_APP_ID',
    messagingSenderId: '...',
    projectId: '...',
    authDomain: '...',
    storageBucket: '...',
  );
}
