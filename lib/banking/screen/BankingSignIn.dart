import 'package:bankingapp/API/local_auth_api.dart';
import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingForgotPassword.dart';
import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/services/phone_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bankingapp/banking/services/user_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BankingSignIn extends StatefulWidget {
  static var tag = "/BankingSignIn";

  @override
  _BankingSignInState createState() => _BankingSignInState();
}

class _BankingSignInState extends State<BankingSignIn> {
  final usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final username = await UserSecureStorage.getUsername() ?? '';

    setState(() {
      this.usernameController.text = username;
    });
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect Credentials'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Your username or password is incorrect, please try again'),
                // Text('Please try again with the correct account number.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth _phoneAuth = FirebaseAuth.instance;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(Banking_lbl_SignIn, style: boldTextStyle(size: 30)),
                TextField(
                  controller: usernameController,
                  style: TextStyle(fontSize: 16),
                  readOnly: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    // errorText: _errorText,
                    hintText: 'Username',
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Banking_Primary),
                    ),
                  ),
                ),
                8.height,
                TextField(
                  controller: passwordController,
                  style: TextStyle(fontSize: 16),
                  readOnly: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    // errorText: _errorText,
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Banking_Primary),
                    ),
                  ),
                ),
                16.height,
                BankingButton(
                  textContent: Banking_lbl_SignIn,
                  onPressed: () async {
                    Map isLoggedin = await userAuth(
                        usernameController.text, passwordController.text);
                    print(isLoggedin['name']);

                    if (isLoggedin.isNotEmpty) {
                      await UserSecureStorage.setUsername(
                          usernameController.text);
                      await UserSecureStorage.setName(isLoggedin['name']);
                      await UserSecureStorage.setAccNum(
                          isLoggedin['accnumber']);
                      await UserSecureStorage.setBank(isLoggedin['bank']);
                      await UserSecureStorage.setPhone(isLoggedin['phone']);
                      await UserSecureStorage.setBalance(isLoggedin['bal']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BankingDashboard(),
                            settings: RouteSettings(arguments: isLoggedin)),
                      );
                    } else {
                      _showErrorDialog(context);
                      return;
                    }
                    // await FirebaseAuth.instance.verifyPhoneNumber(
                    //   phoneNumber: '+15551234567',
                    //   verificationCompleted:
                    //       (PhoneAuthCredential credential) async {
                    //     // ANDROID ONLY!

                    //     // Sign the user in (or link) with the auto-generated credential
                    //     await auth.signInWithCredential(credential);
                    //   },
                    //   verificationFailed: (FirebaseAuthException e) {
                    //     if (e.code == 'invalid-phone-number') {
                    //       print('The provided phone number is not valid.');
                    //     }

                    //     // Handle other errors
                    //   },
                    //   codeSent:
                    //       (String verificationId, int? resendToken) async {
                    //     // Update the UI - wait for the user to enter the SMS code
                    //     String smsCode = 'xxxx';

                    //     // Create a PhoneAuthCredential with the code
                    //     PhoneAuthCredential credential =
                    //         PhoneAuthProvider.credential(
                    //             verificationId: verificationId,
                    //             smsCode: smsCode);

                    //     // Sign the user in (or link) with the credential
                    //     await auth.signInWithCredential(credential);
                    //   },
                    //   codeAutoRetrievalTimeout: (String verificationId) {
                    //     // Auto-resolution timed out...
                    //   },
                    // );
                    // phoneAuthentication();
                    // // BankingDashboard().launch(context, isNewTask: true);
                  },
                ),
                16.height,
                Column(
                  children: [
                    Text(Banking_lbl_Login_with_FaceID,
                            style: primaryTextStyle(
                                size: 16, color: Banking_TextColorSecondary))
                        .onTap(() async {
                      final isAuthenticated =
                          await biomAuthentication.authenticate();
                      if (isAuthenticated == true) {
                        BankingDashboard().launch(context, isNewTask: true);
                      }
                    }),
                    16.height,
                    Image.asset(Banking_ic_face_id,
                        color: Banking_Primary, height: 40, width: 40),
                  ],
                ).center(),
              ],
            ).center(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(Banking_lbl_app_Name.toUpperCase(),
                style: primaryTextStyle(
                    size: 16, color: Banking_TextColorSecondary)),
          ).paddingBottom(16),
        ],
      ),
    );
  }
}
