import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class Authentication {
  static final _auth = LocalAuthentication();
  // ···
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
          options: const AuthenticationOptions(useErrorDialogs: false));
    } on PlatformException catch (e) {
      return false;
    }
    // bool isAuthenticated = false;

    // // if (isBiometricSupported && canCheckBiometrics) {
    // //   isAuthenticated = await auth.authenticate(
    // //     localizedReason: 'Please complete the biometrics to proceed.',
    // //   );
    // // }

    // return isAuthenticated;
  }
}
