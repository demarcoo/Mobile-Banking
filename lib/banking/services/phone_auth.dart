import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class phoneAuthentication {
  static Future phoneAuth(BuildContext context, phoneNum) async {
    print('aaa');
    FirebaseAuth auth = FirebaseAuth.instance;
    final _otpcontroller = TextEditingController();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // print('success');
        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = '';
        // dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter OTP Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _otpcontroller,
                  )
                ],
              ),
              actions: [
                FloatingActionButton(
                  onPressed: () async {
                    smsCode = _otpcontroller.text.trim();

                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential);
                  },
                  child: Text('Done'),
                  backgroundColor: Banking_Primary,
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }
}
