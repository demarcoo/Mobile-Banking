import 'package:bankingapp/API/local_auth_api.dart';
import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingForgotPassword.dart';
import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/services/user_auth_nopass.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/services/phone_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bankingapp/banking/services/user_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

class BankingSignIn extends StatefulWidget {
  static var tag = "/BankingSignIn";

  @override
  _BankingSignInState createState() => _BankingSignInState();
}

class _BankingSignInState extends State<BankingSignIn> {
  final usernameController = TextEditingController();
  bool _isReadOnly = false;
  bool _isEnabled = true;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final username = await UserSecureStorage.getUsername() ?? '';
    if (username != '') {
      setState(() {
        this.usernameController.text = username;
        _isEnabled = false;
        // _isReadOnly = true;
      });
    }
    // print(usernameController.text);
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

  Future<void> _showEmptyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please key in your username and password'),
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

  Future<void> _showFirstSignIn(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Initial Sign-In'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('For first time log in, please use username and password'),
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
    TextEditingController passwordController = TextEditingController();
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Banking_app_logo),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(Banking_lbl_SignIn, style: boldTextStyle(size: 30)),
                      TextField(
                        showCursor: true,
                        focusNode: _usernameFocus,
                        enableInteractiveSelection: false,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_usernameFocus),
                        controller: usernameController,
                        style: TextStyle(fontSize: 16),
                        readOnly: _isReadOnly,
                        enabled: _isEnabled,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          // errorText: _errorText,
                          hintText: 'Username',

                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                      8.height,
                      TextField(
                        focusNode: _passwordFocus,
                        enableInteractiveSelection: false,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _passwordFocus.unfocus(),
                        obscureText: true,
                        controller: passwordController,
                        style: TextStyle(fontSize: 16),
                        readOnly: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          // errorText: _errorText,
                          hintText: 'Password',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                      16.height,
                      BankingButton(
                        textContent: Banking_lbl_SignIn,
                        onPressed: () async {
                          if (usernameController.text != '' &&
                              passwordController.text != '') {
                            Map isLoggedin = await userAuth(
                                usernameController.text,
                                passwordController.text);

                            if (isLoggedin.isNotEmpty) {
                              //set user info
                              await UserSecureStorage.setUsername(
                                  usernameController.text);
                              await UserSecureStorage.setName(
                                  isLoggedin['name']);
                              await UserSecureStorage.setAccNum(
                                  isLoggedin['accnumber']);
                              await UserSecureStorage.setBank(
                                  isLoggedin['bank']);
                              await UserSecureStorage.setPhone(
                                  isLoggedin['phone']);
                              await UserSecureStorage.setBalance(
                                  isLoggedin['bal']);

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankingDashboard(),
                                    settings:
                                        RouteSettings(arguments: isLoggedin)),
                              );
                              passwordController.clear();
                            }
                            if (isLoggedin.isEmpty) {
                              return _showErrorDialog(context);
                            }
                          } else {
                            return _showEmptyDialog(context);
                          }
                        },
                      ),
                      16.height,
                      Column(
                        children: [
                          Text(Banking_lbl_Login_with_FaceID,
                                  style: primaryTextStyle(
                                      size: 16,
                                      color: Banking_TextColorSecondary))
                              .onTap(() async {
                            final name =
                                await UserSecureStorage.getName() ?? '';
                            if (name == '') {
                              return _showFirstSignIn(context);
                            }
                            final isAuthenticated =
                                await biomAuthentication.authenticate();
                            if (isAuthenticated == true) {
                              Map isLoggedin =
                                  await userAuthNoPass(usernameController.text);
                              if (isLoggedin.isNotEmpty) {
                                await UserSecureStorage.setUsername(
                                    usernameController.text);
                                await UserSecureStorage.setName(
                                    isLoggedin['name']);
                                await UserSecureStorage.setAccNum(
                                    isLoggedin['accnumber']);
                                await UserSecureStorage.setBank(
                                    isLoggedin['bank']);
                                await UserSecureStorage.setPhone(
                                    isLoggedin['phone']);
                                await UserSecureStorage.setBalance(
                                    isLoggedin['bal']);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BankingDashboard(),
                                      settings:
                                          RouteSettings(arguments: isLoggedin)),
                                );
                                //clear text field
                                passwordController.clear();
                                usernameController.clear();
                              } else if (isLoggedin.isEmpty) {
                                return _showErrorDialog(context);
                              }
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
        });
  }
}
