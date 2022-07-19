import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/screen/BankingPaymentResult.dart';
import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/API/local_auth_api.dart';
import 'dart:math' as math;
import 'package:bankingapp/banking/services/DecimalFormatter.dart';
import 'dart:io' show Platform;

// ignore: must_be_immutable

class PaymentArguments {
  final String utilityType;

  final double paymentAmount;

  PaymentArguments(this.utilityType, this.paymentAmount);
}

class BankingPaymentDetails extends StatefulWidget {
  static var tag = "/BankingPaymentDetails";
  String? headerText;
  String? paymentImg;
  Color? imgColor;
  Map? accInfo;

  BankingPaymentDetails(
      {this.headerText, required this.paymentImg, this.imgColor, this.accInfo});

  @override
  _BankingPaymentDetailsState createState() => _BankingPaymentDetailsState();
}

class _BankingPaymentDetailsState extends State<BankingPaymentDetails> {
  late List<BankingPaymentModel> mList1;
  late List<BankingPaymentModel> mList2;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool? isValid = false;
  bool _isLoading = false;
  final _otpcontroller = TextEditingController();

  final amountController = TextEditingController();

  late int accNum;
  double? currentBal;

  Future<void> _showEmptyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Invalid OTP. Please try again.'),
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }

  Future<void> _showInsufficientDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Amount'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Transaction failed due to insufficient balance'),
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

  Future<void> _showInvalidOTP(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect OTP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('OTP does not match, please try again.'),
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
  void initState() {
    super.initState();
    mList1 = bankingPaymentDetailList();
    mList2 = bankingPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Account Number', isEqualTo: widget.accInfo!['accnumber'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final double userCurrentBal = (snapshot.data?.docs.first['Balance']);
          return Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  30.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.chevron_left,
                              size: 25, color: Banking_blackColor)
                          .onTap(
                        () {
                          finish(context);
                        },
                      ),
                      20.height,
                      Text(widget.headerText!,
                          style: boldTextStyle(
                              size: 30, color: Banking_TextColorPrimary)),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Image.asset(
                    '${widget.paymentImg}',
                    width: 100,
                    height: 100,
                    color: widget.imgColor,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      width: 180,
                      child: TextField(
                        cursorColor: Banking_Primary,
                        cursorHeight: 16,
                        controller: amountController,
                        style: TextStyle(fontSize: 17),
                        readOnly: false,
                        // onChanged: (value) async {
                        //   if (value.contains('.')) {
                        //     FilteringTextInputFormatter.deny(RegExp(''));
                        //   }
                        // },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          //get 2 decimal places only
                          DecimalTextInputFormatter(decimalRange: 2),
                          LengthLimitingTextInputFormatter(8),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*'))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 17),
                            child: Text(
                              'RM',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          hintText: 'Amount',
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Banking_Primary)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (amountController.text == '' ||
                                double.parse(amountController.text) == 0) {
                              await ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Invalid input, please specify the amount.'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              amountController.clear();
                              return;
                            }

                            double amountPay =
                                double.parse(amountController.text);

                            //check whether user balance is enough

                            if (userCurrentBal < amountPay) {
                              print('Insufficient Balance');
                              return _showInsufficientDialog(context);
                            } else {
                              final isAuthenticated =
                                  await biomAuthentication.authenticate();
                              if (isAuthenticated == true) {
                                // deduct current balance
                                final userNewBal =
                                    await userCurrentBal - amountPay;
                                print(userNewBal);

                                //get doc reference

                                final userPost = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('Account Number',
                                        isEqualTo: widget.accInfo!['accnumber'])
                                    .limit(1)
                                    .get()
                                    .then(
                                  (QuerySnapshot querySnapshot) async {
                                    return querySnapshot.docs[0].reference;
                                  },
                                );

                                //update document in firebase
                                var userBatch =
                                    FirebaseFirestore.instance.batch();
                                userBatch
                                    .update(userPost, {'Balance': userNewBal});
                                await userBatch.commit();

                                //record transaction to firestore database

                                DateTime now = DateTime.now();

                                //store transaction detail

                                await FirebaseFirestore.instance
                                    .collection('transactions')
                                    .add(
                                  {
                                    'Amount': amountPay,
                                    'Recipient': widget.headerText,
                                    'Recipient Name': '',
                                    'Sender': widget.accInfo!['accnumber'],
                                    'Date': now
                                  },
                                );

                                //push to payment result screen

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentResult(),
                                    settings: RouteSettings(
                                      arguments: PaymentArguments(
                                          widget.headerText!, amountPay),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            Icons.payment,
                            color: Banking_Secondary,
                          ),
                          label: Text(
                            'Pay',
                            style: TextStyle(color: Banking_Secondary),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Banking_Primary)),
                        ),
                        (Platform.isAndroid) ? Text('Or') : SizedBox.shrink(),
                        (Platform.isAndroid)
                            ? ElevatedButton.icon(
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (amountController.text == '' ||
                                      double.parse(amountController.text) ==
                                          0) {
                                    await ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Invalid input, please specify the amount.'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );

                                    return;
                                  }
                                  final phoneNum =
                                      await UserSecureStorage.getPhone() ?? '';

                                  // final amountTransfer =
                                  //     double.parse(amountController.text);
                                  if (amountController.text == '') {
                                    return _showEmptyDialog(context);
                                  }
                                  double amountPay =
                                      double.parse(amountController.text);
                                  if (userCurrentBal < amountPay) {
                                    return _showInsufficientDialog(context);
                                  } else {
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                            phoneNumber: phoneNum,
                                            verificationCompleted:
                                                (PhoneAuthCredential
                                                    credential) async {
                                              // print('aaa');
                                            },
                                            verificationFailed:
                                                (FirebaseAuthException e) {
                                              if (e.code ==
                                                  'invalid-phone-number') {
                                                print(
                                                    'The provided phone number is not valid.');
                                              }
                                              if (e.message!.contains(
                                                  'invalid-verification-code')) {
                                                print('wrong code');
                                              }
                                              // Handle other errors
                                            },
                                            codeSent: (String verificationId,
                                                int? resendToken) async {
                                              // Update the UI - wait for the user to enter the SMS code
                                              String smsCode = '';
                                              // dialog
                                              isValid = await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Enter OTP Code'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                6)
                                                          ],
                                                          controller:
                                                              _otpcontroller,
                                                        )
                                                      ],
                                                    ),
                                                    actions: [
                                                      FloatingActionButton(
                                                        onPressed: () async {
                                                          smsCode =
                                                              _otpcontroller
                                                                  .text
                                                                  .trim();

                                                          // Create a PhoneAuthCredential with the code
                                                          PhoneAuthCredential
                                                              credential =
                                                              PhoneAuthProvider.credential(
                                                                  verificationId:
                                                                      verificationId,
                                                                  smsCode:
                                                                      smsCode);
                                                          if (smsCode
                                                              .isEmptyOrNull) {
                                                            return _showEmptyDialog(
                                                                context);
                                                          }

                                                          // Sign the user in (or link) with the credential

                                                          try {
                                                            await auth
                                                                .signInWithCredential(
                                                                    credential)
                                                                .then(
                                                              (value) async {
                                                                final userNewBal =
                                                                    await userCurrentBal -
                                                                        amountPay;

                                                                print(
                                                                    userNewBal);

                                                                final accNum =
                                                                    await UserSecureStorage
                                                                            .getAccNum() ??
                                                                        '';
                                                                final userBank =
                                                                    await UserSecureStorage
                                                                            .getBank() ??
                                                                        '';
                                                                final name =
                                                                    await UserSecureStorage
                                                                            .getName() ??
                                                                        '';

                                                                final userPost = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .where(
                                                                        'Account Number',
                                                                        isEqualTo:
                                                                            int.parse(
                                                                                accNum))
                                                                    .where(
                                                                        'Bank',
                                                                        isEqualTo:
                                                                            userBank)
                                                                    .limit(1)
                                                                    .get()
                                                                    .then(
                                                                  (QuerySnapshot
                                                                      querySnapshot) async {
                                                                    return querySnapshot
                                                                        .docs[0]
                                                                        .reference;
                                                                  },
                                                                );
                                                                var userBatch =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .batch();
                                                                userBatch
                                                                    .update(
                                                                  userPost,
                                                                  {
                                                                    'Balance':
                                                                        userNewBal
                                                                  },
                                                                );
                                                                await userBatch
                                                                    .commit();

                                                                //update recipient balance

                                                                DateTime now =
                                                                    DateTime
                                                                        .now();

                                                                //store transaction details

                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'transactions')
                                                                    .add({
                                                                  'Amount':
                                                                      amountPay,
                                                                  'Recipient':
                                                                      widget
                                                                          .headerText,
                                                                  'Recipient Name':
                                                                      '',
                                                                  'Sender': widget
                                                                          .accInfo![
                                                                      'accnumber'],
                                                                  'Date': now
                                                                });
                                                                finish(context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PaymentResult(),
                                                                    settings:
                                                                        RouteSettings(
                                                                      arguments: PaymentArguments(
                                                                          widget
                                                                              .headerText!,
                                                                          amountPay),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).catchError(
                                                              (err) {
                                                                //action if wrong OTP
                                                                if (err
                                                                    .toString()
                                                                    .contains(
                                                                        'invalid-verification-code')) {
                                                                  _showInvalidOTP(
                                                                      context);
                                                                  _otpcontroller
                                                                      .clear();
                                                                }
                                                              },
                                                            );
                                                          } catch (e) {
                                                            return;
                                                          }
                                                        },
                                                        child: Text('Verify'),
                                                        backgroundColor:
                                                            Banking_Primary,
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            codeAutoRetrievalTimeout:
                                                (String verificationId) {
                                              // Auto-resolution timed out...
                                            });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Banking_Primary),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.pin,
                                  color: Banking_Secondary,
                                ),
                                label: Text(
                                  'Use OTP Instead',
                                  style: TextStyle(
                                      color: Banking_Secondary, fontSize: 18),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
