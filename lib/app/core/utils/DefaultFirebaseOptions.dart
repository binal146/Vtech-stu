import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    if (defaultTargetPlatform case TargetPlatform.android) {
      return android;
    } else if (defaultTargetPlatform case TargetPlatform.iOS) {
      return ios;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKHMsR-hlUOz201MnTSR41IHDoKP_nOd4',
    appId: '1:99081688167:android:9894cbbbcdc3c9a7a430c2',
    messagingSenderId: '99081688167',
    projectId: 'foodiv',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKHMsR-hlUOz201MnTSR41IHDoKP_nOd4',
    appId: '1:99081688167:android:9894cbbbcdc3c9a7a430c2',
    messagingSenderId: '99081688167',
    projectId: 'foodiv',
    androidClientId: '1085885089042-lfli725bcgl4g48o3lp4ig6ggpmerd80.apps.googleusercontent.com',
    iosClientId: '',
    iosBundleId: '',
  );


}
